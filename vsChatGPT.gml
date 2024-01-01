global.api_host = "https://api.openai.com/v1/";
global.OpenAI_Key = "OpenAI-Key";
global.OpenAI_OrgID = "";

/// @function					callAPI(request, payload, method);
/// @param	{real}	request		OpenAI Endpoint
/// @param	{real}	payload		JSON Payload
/// @param	{real}	method		GET, POST, DELETE, PUT


function callAPI(request="", payload=false, method="POST"){
	var headers = ds_map_create();
    ds_map_add(headers, "Authorization", "Bearer " + global.OpenAI_Key);
	if(global.OpenAI_OrgID != "") ds_map_add(headers, "OpenAI-Organization", global.OpenAI_OrgID);
	ds_map_add(headers, "Content-Type", "application/json");

	var url = (global.api_host + request);
    var response_id = http_request(url, method, headers, json_encode(payload));

	if(payload) ds_map_destroy(payload);
    ds_map_destroy(headers);

	return response_id;
}

function createMSG(role="", text=""){
	return createMSGFull(role, false, text);
}
function createMSGFull(role="user", name="", text="", detail="low"){
	var msg = ds_map_create();
	ds_map_add(msg, "role", role);
	if(name && name != "") ds_map_add(msg, "name", name);

	ds_map_add(msg, "content", text);

	return msg;
}

function vsEncode(msgs){
    // Manually constructing JSON
    var jsonString = "{ \"messages\": [";
    for (var i = 0; i < ds_list_size(msgs); i++) {
        var msgMap = ds_list_find_value(msgs, i);
        jsonString += json_encode(msgMap);
        if (i < ds_list_size(msgs) - 1) {
            jsonString += ",";
        }
    }
    jsonString += "] }";
	
	ds_map_destroy(msgs);

	return json_decode(jsonString);
}

function chat(prompt="", msgs=false, model="gpt-3.5-turbo", para=false, fncs=false){
	if(!msgs) msgs = ds_list_create();
	
	ds_list_add(msgs, createMSG("user", prompt));
	show_debug_message("chat: "+ json_encode(msgs));

	return chatNop(msgs, model, para, fncs);
}

function chatNop(msgs=false, model="gpt-3.5-turbo", para=false, fncs=false){
	if(!para) para = vsEncode(msgs);
	
	ds_map_add(para, "model", model);
	if(ds_map_exists(para, "temperature")) ds_map_add(para, "temperature", 0.7);

	return callAPI("chat/completions", para);
}
