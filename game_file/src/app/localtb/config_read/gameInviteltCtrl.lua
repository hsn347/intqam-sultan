local gameInviteltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "inviteaward"
	;(nil)[2] = true
	gameInviteltCtrl:defineValue("awardList", nil)
	gameInviteltCtrl = nil
	;(nil)[1] = "inviteawardview"
	gameInviteltCtrl:defineValue("showAwardList", nil)
	gameInviteltCtrl:defineValue("platFormList", function()
		_UPVALUE0_, _UPVALUE4_ = nil, nil
		;(nil).id = 1
		;(nil).platform = "facebook"
		;(nil).title = "FaceBook"
		_UPVALUE0_, (nil).icon = nil, "icon_facebook.png"
		;(nil).id = 2
		;(nil).platform = "whatsapp"
		;(nil).title = "WhatsApp"
		_UPVALUE0_, (nil).icon = nil, "icon_set_seting_whatsapp.png"
		;(nil).id = 3
		;(nil).platform = "telegram"
		;(nil).title = "Telegram"
		;(nil).icon = "icon_telegram.png"
		_UPVALUE0_, (nil).exclusive = nil, "fa"
		;(nil).id = 4
		;(nil).platform = "kakootalk"
		;(nil).title = "KakooTalk"
		;(nil).icon = "icon_kakaotalk.png"
		;(nil)[1] = nil
		;(nil)[2] = nil
		;(nil)[3] = nil
		;(nil)[4] = nil
		return nil
	end)
	gameInviteltCtrl:defineValue("platformSet", function()
		_UPVALUE2_, _UPVALUE0_ = nil, nil
		_UPVALUE1_, (nil).en, (nil)[1] = nil, nil, 1
		_UPVALUE1_, (nil).en, (nil)[2] = nil, nil, 2
		_UPVALUE1_, (nil).ko_android, (nil)[1] = nil, nil, 1
		_UPVALUE1_, (nil).ko_ios, (nil)[1] = nil, nil, 1
		_UPVALUE1_, (nil).ko_onestore, (nil)[1] = nil, nil, 1
		_UPVALUE2_, (nil).fa, (nil)[1] = nil, nil, 3
		;(nil).ar, (nil)[1] = nil, 1
		;(nil).ar, (nil)[2] = nil, 2
		return nil
	end)
end
init()
function gameInviteltCtrl.getItemListByType(gType)
	local _ENV, ret
	for i, v in ipairs(gameInviteltCtrl.awardList) do
		if v.type == gType then
			table.insert(ret, v)
		end
	end
	return ret
end
function gameInviteltCtrl.getShowItemListByType(gType)
	local ret
	for i, v in ipairs(gameInviteltCtrl.showAwardList) do
		if v.type == gType then
			ret = v
		end
	end
	if not ret or not ret.ShowLlist then
		_ENV = ret.ShowLlist
	end
	return ret.ShowLlist
end
function gameInviteltCtrl.getPlatformByVersion(_id)
	local findExclusive = function(platformlist, _channel)
		local gameInviteltCtrl, ret
		if not gameInviteltCtrl.platformSet[_channel] then
			local gameInviteltCtrl, set = gameInviteltCtrl.platformSet[_channel], gameInviteltCtrl.platformSet[_channel]
		end
		for _, v in ipairs(set) do
			table.insert(ret, gameInviteltCtrl.platFormList[v])
		end
		return ret
	end
	if _id then
		for i, v in ipairs(gameInviteltCtrl.platFormList) do
			if v.id == _id then
				return v
			end
		end
	else
		local channel = userSDKManager.getChannel()
		return findExclusive(gameInviteltCtrl.platFormList, channel)
	end
end
return gameInviteltCtrl
