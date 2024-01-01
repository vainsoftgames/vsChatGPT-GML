# vsChatGPT-GML
OpenAI API in GameMaker

This is an “unofficial" OpenAI library that I maintain.

<br/><br/>
Using vsChatGPT, just need to download/copy the objects & scripts folders into your game.

<br/><br/>

Setting OpenAI Key
<br/>Don't hardcode your API Key's in your game, huge security concerns with that. Specially if you export as HTML5.
````
global.OpenAI_Key = "OpenAI Key"
````

Setup callback function
````
function vsChatGPT_response(data){
  show_debug_message("WE HAVE DATA");
  show_debug_message(json_encode(data));
}

// Declare callback function
global.vsChatGPTCallback = vsChatGPT_response;
// Declare response ID (calls are async)
global.vsChatGPTID = chat("How are you today");
````


Building out a convesation
````

var msgs = ds_list_create()
ds_list_add(msgs, createMSG("user", "prompt"));

````


# Full Example
````
// Will output map with id, model, usage, & content parameters
function vsChatGPT_response(data){
  show_debug_message("WE HAVE DATA");
  show_debug_message(json_encode(data));
}


var msgs = ds_list_create()
ds_list_add(msgs, createMSG("system", "You are an AI that helps with GameMaker dialog."));
ds_list_add(msgs, createMSG("user", "Start a conversation with Luna & Cheeda."));

global.vsChatGPTCallback = vsChatGPT_response;
global.vsChatGPTID = chatNop(msgs, "gpt-4-turbo");
````



# The different functions
````
// Create a MSG
var msg = createMSG("role", "prompt");

// Create a Message with Username
var msg = createMSGFull("role", "user", "prompt");

// Call OpenAI directly with prompt
var responseID = chat("prompt", msgs, "GPT Model");


// Call OpenAI with array of messages already setup
var responseID = chatNop(msgs, "GPT Model")
````
