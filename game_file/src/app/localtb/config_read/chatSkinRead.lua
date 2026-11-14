local chatSkinRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	chatSkinRead = nil
	;(nil)[1] = "chatskin"
	chatSkinRead:defineValue("chatSkin", nil)
	chatSkinRead = nil
	;(nil)[1] = "bubble_widget_cfg"
	chatSkinRead:defineValue("bubble_widget_cfg", nil)
	chatSkinRead = nil
	;(nil)[1] = "headwear_cfg"
	chatSkinRead:defineValue("headwear_cfg", nil)
	chatSkinRead = nil
	;(nil)[1] = "avatarframe_cfg"
	chatSkinRead:defineValue("avatarframe_cfg", nil)
	chatSkinRead:defineValue("bubble_cfg", function()
		local bubble_cfg = require("app." .. LocalTblPath .. ".config_client.bubble_cfg")
		for _, v in pairs(bubble_cfg) do
			v.fontcolor_rgb = SoraDHtmlColor2RGB(v.fontcolor)
			v.bottomcolor_rgb = SoraDHtmlColor2RGB(v.bottomcolor)
			v.linkcolor_rgb = SoraDHtmlColor2RGB(v.linkcolor)
			v.audiocolor_rgb = SoraDHtmlColor2RGB(v.audiocolor)
			v.audioplaycolor_rgb = SoraDHtmlColor2RGB(v.audioplaycolor)
		end
		return bubble_cfg
	end)
end
init()
function chatSkinRead.getHeadIDByCid(cid)
	local cid = tonumber(cid)
	local headType = gAvatarFrameId.AVATAR_FRAME_ID_NORMAL
	local chatSkinData = chatSkinRead.chatSkin[cid]
	if chatSkinData and next(chatSkinData) and chatSkinData.content == 2 then
		headType = chatSkinData.Type
	end
	return headType
end
function chatSkinRead.getBubbleIDByCid(cid)
	local cid = tonumber(cid)
	local chatType = gBubbleId.BUBBLE_ID_NORMAL
	local chatSkinData = chatSkinRead.chatSkin[cid]
	if chatSkinData and next(chatSkinData) and chatSkinData.content == 1 then
		chatType = chatSkinData.Type
	end
	return chatType
end
function chatSkinRead.getHeadWearIDByCid(cid)
	local cid = tonumber(cid)
	local chatType = gHeadWearId.HEAD_ID_NORMAL
	local chatSkinData = chatSkinRead.chatSkin[cid]
	if chatSkinData and next(chatSkinData) and chatSkinData.content == 3 then
		chatType = chatSkinData.Type
	end
	return chatType
end
function chatSkinRead.getBubbleCfg(bubbleId)
	return chatSkinRead.bubble_cfg[tonumber(bubbleId)]
end
function chatSkinRead.getBubbleWidgets(bubbleId)
	local bubbleCfg = chatSkinRead.getBubbleCfg(bubbleId)
	local ret
	if bubbleCfg then
		for i, v in ipairs(bubbleCfg.widgets) do
			if ret == nil then
				ret, chatSkinRead = nil, nil
			end
			local widget = chatSkinRead.getBubbleWidget(bubbleId, v)
			if widget then
				table.insert(ret, widget)
			end
		end
	end
	return ret
end
function chatSkinRead.getBubbleWidget(bubbleId, widgetId)
	return chatSkinRead.bubble_widget_cfg[widgetId]
end
function chatSkinRead.getEmoticon(packetId, emoticonId)
	return "chat_face_1.png"
end
function chatSkinRead.getHeadWearCfg(headWearId)
	return chatSkinRead.headwear_cfg[tonumber(headWearId)]
end
function chatSkinRead.getAvatarFrameCfg(avatarFrameId)
	return chatSkinRead.avatarframe_cfg[tonumber(avatarFrameId)]
end
return chatSkinRead
