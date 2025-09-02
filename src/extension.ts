import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import fetch from 'node-fetch';
import unzipper from 'unzipper';
import { exec } from 'child_process';
import * as util from 'util';
const execAsync = util.promisify(exec);

async function downloadAndExtractZip(url: string, destPath: string) {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Failed to fetch zip: ${url}`);

  const buffer = Buffer.from(await res.arrayBuffer());
  const stream = require('stream');
  const bufferStream = new stream.PassThrough();
  bufferStream.end(buffer);

  await new Promise<void>((resolve, reject) => {
    bufferStream
      .pipe(unzipper.Extract({ path: destPath }))
      .on('close', resolve)
      .on('error', reject);
  });
}

async function getLatestReleaseZipUrl(owner: string, repo: string, assetName: string): Promise<string> {
    const res = await fetch(`https://api.github.com/repos/${owner}/${repo}/releases/latest`);
    if (!res.ok) throw new Error(`Failed to fetch latest release info`);

    const data = await res.json();
    const asset = data.assets.find((a: any) => a.name === assetName);
    if (!asset) throw new Error(`Asset '${assetName}' not found in latest release`);

    return asset.browser_download_url;
}

function ensureVscodeSettings(folder: string, extraSettings: Record<string, any>) {
    const vscodePath = path.join(folder, '.vscode');
    fs.mkdirSync(vscodePath, { recursive: true });

    const settingsFile = path.join(vscodePath, 'settings.json');
    let settings: Record<string, any> = {};

    if (fs.existsSync(settingsFile)) {
        try {
            settings = JSON.parse(fs.readFileSync(settingsFile, 'utf-8'));
        } catch {
            settings = {};
        }
    }

    for (const key in extraSettings) {
        if (Array.isArray(extraSettings[key])) {
            if (!Array.isArray(settings[key])) settings[key] = [];
            settings[key] = Array.from(new Set([...settings[key], ...extraSettings[key]]));
        } else {
            settings[key] = extraSettings[key];
        }
    }

    fs.writeFileSync(settingsFile, JSON.stringify(settings, null, 2));
}

function sanitizeModName(name: string): string {
    let sanitized = name.replace(/\s+/g, '_').toLowerCase();
    sanitized = sanitized.replace(/[^a-z_]/g, '');
    return sanitized;
}

function modNameToClass(name: string): string {
    let cleaned = name.replace(/[^a-zA-Z\s]/g, '');
    return cleaned
        .split(/[\s_]+/)
        .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
        .join('');
}

function getCurrentDate(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0'); 
    const day = String(now.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

export async function activate(context: vscode.ExtensionContext) {

    let disposable = vscode.commands.registerCommand('kcd-utils-template.createLuaMod', async () => {

        const folderUri = await vscode.window.showOpenDialog({ canSelectFolders: true });
        if (!folderUri) return;
        const rootPath = folderUri[0].fsPath;

        let modNameInput = await vscode.window.showInputBox({ prompt: 'Mod Name / Entry Lua Table Name' });
        if (!modNameInput) return;

        const modName = sanitizeModName(modNameInput);
        const className = modNameToClass(modNameInput);

        const modFolder = path.join(rootPath, modName);
        if (fs.existsSync(modFolder)) {
            const overwrite = await vscode.window.showWarningMessage(
                `The folder '${modName}' already exists. Overwrite?`,
                'Yes', 'No'
            );
            if (overwrite !== 'Yes') return;
        }

const modScriptsPath = path.join(modFolder, 'Data', modName, 'Scripts', 'Mods');
        fs.mkdirSync(modScriptsPath, { recursive: true });

        // --- create inner folder Scripts/Mods/<modName>/ and ensure it exists ---
        const modInnerScriptsPath = path.join(modScriptsPath, className);
        fs.mkdirSync(modInnerScriptsPath, { recursive: true });

        const luaTemplatePath = context.asAbsolutePath(path.join('templates', 'mod.lua'));
        let luaTemplate = fs.readFileSync(luaTemplatePath, 'utf-8');
        luaTemplate = luaTemplate.replace(/{{MODNAME_CLASS}}/g, className);
        // main entry file at Scripts/Mods/<modName>.lua
        fs.writeFileSync(path.join(modScriptsPath, `${modName}.lua`), luaTemplate);

        // --- NEW: copy config.lua template into Scripts/Mods/<modName>/config.lua ---
        const configTemplatePath = context.asAbsolutePath(path.join('templates', 'config.lua'));
        if (fs.existsSync(configTemplatePath)) {
            let configTemplate = fs.readFileSync(configTemplatePath, 'utf-8');
            configTemplate = configTemplate
                .replace(/{{MODNAME_FOLDER}}/g, modName)
                .replace(/{{MODNAME_CLASS}}/g, className);
            fs.writeFileSync(path.join(modInnerScriptsPath, 'config.lua'), configTemplate);
        } else {
            vscode.window.showWarningMessage("config.lua template not found in extension templates folder.");
        }

        const templatePath = context.asAbsolutePath(path.join('templates', 'mod.manifest'));
        let manifestTemplate = fs.readFileSync(templatePath, 'utf-8');
        manifestTemplate = manifestTemplate
            .replace(/{{MODNAME_FOLDER}}/g, modName)
            .replace(/{{MODNAME_CLASS}}/g, className)
            .replace(/{{DATE}}/g, getCurrentDate());
        fs.writeFileSync(path.join(modFolder, 'mod.manifest'), manifestTemplate);

        try {
            const url = await getLatestReleaseZipUrl('Destuur', 'KCDUtils', 'kcdutils.zip');
            await downloadAndExtractZip(url, rootPath);
        } catch (err) {
            vscode.window.showErrorMessage(`Error downloading KCDUtils: ${err}`);
            return;
        }

        // KCDUtils VSCode settings
        const kcdutilsFolder = path.join(rootPath, '_kcdutils', 'Data', 'kcdutils');
        ensureVscodeSettings(kcdutilsFolder, {
            "Lua.diagnostics.globals": ["System", "Script"]
        });

        // Mod VSCode settings auf Root-Level (neben .git)
        const modFolderPath = path.join(modFolder, 'Data', modName);
        ensureVscodeSettings(modFolderPath, {
            "Lua.workspace.library": [
                path.join(rootPath, '_kcdutils', 'Data', 'kcdutils', 'Scripts', 'Mods')
            ],
            "Lua.diagnostics.globals": ["System", "Script", "ScriptLoader"]
        });

        // Workspace-Datei ebenfalls auf Root-Level
        const workspacePath = path.join(modFolder, `${modName}.code-workspace`);
        const workspace = {
            folders: [
                { path: path.join(modFolder, 'Data', modName) },
                { path: path.join(rootPath, '_kcdutils', 'Data', 'kcdutils') }
            ],
            settings: {}
        };
        fs.writeFileSync(workspacePath, JSON.stringify(workspace, null, 2));

        // --- Optional Git Init & Push ---
        const gitInitAnswer = await vscode.window.showQuickPick(
            ['Yes', 'No'],
            { placeHolder: 'Initialize a git repository for this mod and push to GitHub?' }
        );

        if (gitInitAnswer === 'Yes') {
            const githubUrl = await vscode.window.showInputBox({ prompt: 'GitHub Repo URL (HTTPS, optional)' });
            try {
                await execAsync(`git init`, { cwd: modFolder });
                await execAsync(`git checkout -b main`, { cwd: modFolder });
                await execAsync(`git add .`, { cwd: modFolder });
                await execAsync(`git commit -m "Initial commit"`, { cwd: modFolder });

                if (githubUrl) {
                    await execAsync(`git remote add origin ${githubUrl}`, { cwd: modFolder });
                    await execAsync(`git push -u origin main`, { cwd: modFolder });
                    vscode.window.showInformationMessage('Git repository initialized locally and pushed to GitHub!');
                } else {
                    vscode.window.showInformationMessage('Git repository initialized locally (no remote set).');
                }
            } catch (err: any) {
                vscode.window.showErrorMessage(`Git error: ${err.message || err}`);
            }
        }

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
