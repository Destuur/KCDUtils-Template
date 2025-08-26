import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import fetch from 'node-fetch';

const unzipper = require('unzipper');

async function downloadAndExtractZip(url: string, destPath: string) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`Failed to fetch zip: ${url}`);

    const buffer = Buffer.from(await res.arrayBuffer());
    const stream = require('stream');
    const bufferStream = new stream.PassThrough();
    bufferStream.end(buffer);

    await new Promise<void>((resolve, reject) => {
        bufferStream
            .pipe(unzipper.Parse())
            .on('entry', (entry: any) => {
                // entry.path enthält den Pfad in der ZIP
                const relativePath = entry.path.replace(/^kcdutils[\\/]/, ''); // optional: obersten Ordner entfernen
                const targetPath = path.join(destPath, 'kcdutils', relativePath);

                if (entry.type === 'Directory') {
                    fs.mkdirSync(targetPath, { recursive: true });
                    entry.autodrain();
                } else {
                    fs.mkdirSync(path.dirname(targetPath), { recursive: true });
                    entry.pipe(fs.createWriteStream(targetPath));
                }
            })
            .on('close', resolve)
            .on('error', reject);
    });
}

// Variant 1: for folder / Lua file name
function sanitizeModName(name: string): string {
    // Replace spaces with underscores, make lowercase, allow only a-z and _
    let sanitized = name.replace(/\s+/g, '_').toLowerCase();
    sanitized = sanitized.replace(/[^a-z_]/g, '');
    return sanitized;
}

// Variant 2: for Lua class / table name
function modNameToClass(name: string): string {
    // Remove all special characters and numbers
    let cleaned = name.replace(/[^a-zA-Z\s]/g, '');
    // Split by spaces and underscores, capitalize each component
    return cleaned
        .split(/[\s_]+/)
        .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
        .join('');
}

function getCurrentDate(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0'); // Month 0-11 → +1
    const day = String(now.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

export async function activate(context: vscode.ExtensionContext) {

    // Register the command for creating a Lua mod template
    let disposable = vscode.commands.registerCommand('kcd-utils-template.createLuaMod', async () => {

    // 1. Select target folder
        const folderUri = await vscode.window.showOpenDialog({ canSelectFolders: true });
        if (!folderUri) return;
        const rootPath = folderUri[0].fsPath;

    // 2. Ask for mod name
        let modNameInput = await vscode.window.showInputBox({ prompt: 'Mod Name / Entry Lua Table Name' });
        if (!modNameInput) return;

    // Sanitize modName
        const modName = sanitizeModName(modNameInput);
        const className = modNameToClass(modNameInput);

    // 3. Check if mod folder already exists
        const modFolder = path.join(rootPath, modName);
        if (fs.existsSync(modFolder)) {
            const overwrite = await vscode.window.showWarningMessage(
                `Der Ordner '${modName}' existiert bereits. Überschreiben?`,
                'Ja', 'Nein'
            );
            if (overwrite !== 'Ja') return;
        }

    // ---------------------------
    // Create modName folder structure
    // ---------------------------
        const modScriptsPath = path.join(modFolder, 'Data', modName, 'Scripts', 'Mods');
        fs.mkdirSync(modScriptsPath, { recursive: true });

    // ---------------------------
    // Create Lua file from template
    // ---------------------------
        const luaTemplatePath = context.asAbsolutePath(path.join('templates', 'mod.lua'));
        let luaTemplate = fs.readFileSync(luaTemplatePath, 'utf-8');

    // Replace placeholders in Lua template
        luaTemplate = luaTemplate.replace(/{{MODNAME_CLASS}}/g, className);
        fs.writeFileSync(path.join(modScriptsPath, `${modName}.lua`), luaTemplate);

    // ---------------------------
    // Create mod.manifest from template
    // ---------------------------
        const templatePath = context.asAbsolutePath(path.join('templates', 'mod.manifest'));
        let manifestTemplate = fs.readFileSync(templatePath, 'utf-8');

    // Replace placeholders in manifest template
        manifestTemplate = manifestTemplate
            .replace(/{{MODNAME_FOLDER}}/g, modName)
            .replace(/{{MODNAME_CLASS}}/g, className)
            .replace(/{{DATE}}/g, getCurrentDate());

        fs.writeFileSync(path.join(modFolder, 'mod.manifest'), manifestTemplate);
        

    // ---------------------------
    // Download and extract kcdutils folder as ZIP
    // ---------------------------
    await vscode.window.showInformationMessage('KCDUtils will be downloaded as ZIP and extracted...');
        try {
            await downloadAndExtractZip(
                'https://github.com/Destuur/KCDUtils/releases/download/0.0.1/kcdutils.zip',
                rootPath
            );  
        } catch (err) {
            vscode.window.showErrorMessage(`Error downloading KCDUtils: ${err}`);
            return;
        }

    // ---------------------------
    // Create VS Code settings.json for Lua workspace library
    // ---------------------------
        const vscodePath = path.join(modFolder, 'Data', modName, '.vscode');
        fs.mkdirSync(vscodePath, { recursive: true });
        const settings = {
            "Lua.workspace.library": [
                path.join(rootPath, 'kcdutils', 'Data', 'kcdutils', 'Scripts', 'Mods', 'Utils')
            ]
        };
        fs.writeFileSync(path.join(vscodePath, 'settings.json'), JSON.stringify(settings, null, 2));

    // ---------------------------
    // Create VS Code workspace file
    // ---------------------------
        const workspacePath = path.join(modFolder, 'Data', modName, `${modName}.code-workspace`);

        const workspace = {
            folders: [
                { path: path.join(modFolder, 'Data', modName) },
                { path: path.join(rootPath, 'kcdutils', 'Data', 'kcdutils') }
            ],
            settings: {}
        };

        fs.writeFileSync(workspacePath, JSON.stringify(workspace, null, 2));

        // 4. Final info message
        const open = await vscode.window.showInformationMessage(
            `Lua mod '${modName}' with KCDUtils created!`,
            'Open workspace'
        );
        if (open === 'Open workspace') {
            vscode.commands.executeCommand('vscode.openFolder', vscode.Uri.file(workspacePath));
        }
    });

    context.subscriptions.push(disposable);
}

export function deactivate() {}
