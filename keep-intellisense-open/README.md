# keep-intellisense-open
Keeps intellisense open when you click outside of (or defocus) the editor. (Made for use with [MultiUser](https://github.com/Somebody32x2/MultiUser))

TO USE: 
1. Install the .vsix extension
2. Open Browser VS Code (`(...) Help > Toggle Developer Tools`)
3. a. Read through the below script to ensure it's not malware !! NEVER BLINDLY PASTE SCRIPTS !!
3. b. Paste in the below script with the port number prompted by the extension message in the bottom right (often 8081)

```javascript
let ws = new WebSocket("ws:localhost:8081")

function setExtObserver () {
    if (!document.querySelectorAll(`[widgetid="editor.widget.suggestWidget"`)[0]){
        setTimeout(setExtObserver, 100)
        return;
    }
    const suggest_element = document.querySelectorAll(`[widgetid="editor.widget.suggestWidget"`)[0]

const observer = new MutationObserver((mutations) => {
  mutations.forEach((mutation) => {
    if (mutation.attributeName === 'class') {
      console.log(suggest_element.classList.contains("visible"));
      ws.send(suggest_element.classList.contains("visible"))
    }
  });
});
observer.observe(suggest_element, { attributes: true });}
setExtObserver()
```
