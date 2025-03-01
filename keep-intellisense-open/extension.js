// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below

const vscode = require('vscode');
const ws = require('ws');

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed


/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {

	// Use the console to output diagnostic information (console.log) and errors (console.error)
	// This line of code will only be executed once when your extension is activated
	console.log('Congratulations, your extension "keep-intellisense-open" is now active!');

	// The command has been defined in the package.json file
	// Now provide the implementation of the command with  registerCommand
	// The commandId parameter must match the command field in package.json
	const disposable = vscode.commands.registerCommand('keep-intellisense-open.helloWorld', function () {
		// The code you place here will zbe executed every time your command is executed
		vscode.commands.executeCommand("getContext", "suggestWidgetMultipleSuggestions").then(r=>console.log(r))
		// Display a message box to the user
		vscode.window.showInformationMessage('Hello World infrom Keep Intellisense Open!');
	});

	context.subscriptions.push(disposable);
	// register handler for onDidChangeWindowState
	let recent_suggest_closes = []
	let recent_window_closes = []
	let isOpen = true
	let lastReopen = 0
	vscode.window.onDidChangeWindowState((e) => {
		// if (e.focused) {
			// vscode.commands.executeCommand('editor.action.triggerSuggest');
		// } 
		// console.log(e)
		if (!e.focused) {
			recent_window_closes.unshift(new Date().getTime())
			// console.log(recent_window_closes.filter(e=>{console.log((new Date().getTime() - e)); return (new Date().getTime() - e) < (30 * 1000)}))
			recent_window_closes = recent_window_closes.filter(e=>{return (new Date().getTime() - e) < (30 * 1000)})
			// console.log({recent_suggest_closes})
			// console.log({recent_window_closes})
			isOpen = false
			console.log({isOpen})

			// if the suggest was just closed, reopen while the window is closed
			if (recent_suggest_closes.length > 0){
				console.log({"dreopen" : new Date().getTime() - lastReopen, "drsugclose": new Date().getTime() - recent_suggest_closes[0], isOpen})
				if (new Date().getTime() - lastReopen > 100 && new Date().getTime() - recent_suggest_closes[0] < 100 && !isOpen){
					vscode.commands.executeCommand('editor.action.triggerSuggest');
					lastReopen = new Date().getTime()

				}
			}
		} else {
			// if we closed the suggest and the window at about the same time, reopen the suggest
			console.log("delta " + (recent_window_closes[0] - recent_suggest_closes[0]))
			if (recent_window_closes[0] - recent_suggest_closes[0] < 100){
				vscode.commands.executeCommand('editor.action.triggerSuggest');
			}
			isOpen = true
			console.log({isOpen})
		}
	});
	console.log(vscode)
	console.log("starting server")
	// console.log(vscode.env.FPS_BROWSER_APP_PROFILE_STRING), 2000)
	let PORT = 8080
	let wss = undefined
	while (!wss) {
		try	{
			wss = new ws.WebSocketServer({ port: PORT });
		} catch {
			PORT += 1
		}
    }  
	vscode.window.showInformationMessage('Listening on port ' + PORT);
	
	wss.on('connection', function connection(ws) {
	ws.on('error', console.error);

	

	ws.on('message', function message(data) {
		// console.log(data.byteLength);
		if (data.byteLength == 5) { // 5 for "false", 4 for "true"
			recent_suggest_closes.unshift(new Date().getTime())
			recent_suggest_closes = recent_suggest_closes.filter(e=>{return (new Date().getTime() - e) < (30 * 1000)})
			// console.log({recent_suggest_closes})
			// console.log({recent_window_closes})

		}
	});

	ws.send('something');
	});

}

// This method is called when your extension is deactivated
function deactivate() {}

module.exports = {
	activate,
	deactivate
}

// "suggestWidgetMultipleSuggestions"
