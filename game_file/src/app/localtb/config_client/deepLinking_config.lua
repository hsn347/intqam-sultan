local gotostore_work = function(...)
	print("记录跳转支付的")
	local args = (...)
	dump(args, "deepLinking args")
	local rechargeId = args.argList
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeID = rechargeId
		uiManager:show("rechargeView", nil)
	elseif not SoraDSearchPanelFromManagerByName("rechargeView") then
		local panel = SoraDCreatePanel("rechargeView")
		panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, rechargeId)
		panel:show()
	end
	deepLinking.log2server(args.host, args.param, "", args.argList)
end
local log_work = function(...)
	print("不做事 记录上传日志")
	local args = (...)
	deepLinking.log2server(args.host, args.param, "", args.argList)
end
_ENV, _ENV = nil, nil
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Facebook-Reengagement"
;(nil).param = "Re-Engagement-Anniversary"
_ENV, (nil)[1], (nil).work = nil, nil, function(...)
	print("打开周年庆")
	local args = (...)
	deepLinking.log2server(args.host, args.param, "9911", args.argList)
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Facebook-Reengagement"
;(nil).param = "Engagement-Eid-al-Adha"
_ENV, (nil)[2], (nil).work = nil, nil, function(...)
	print("打开宰生节")
	local args = (...)
	deepLinking.log2server(args.host, args.param, "10021", args.argList)
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Facebook-Reengagement"
;(nil).param = "Re-Engagement-Online"
_ENV, (nil)[3], (nil).work = nil, nil, function(...)
	print("不做事 记录fb连接进来的")
	local args = (...)
	deepLinking.log2server(args.host, args.param, "", args.argList)
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "IM-InviteCode"
;(nil).param = "codeNum"
_ENV, (nil)[4], (nil).work = nil, nil, function(...)
	print("邀请码")
	local args = (...)
	dump(args, "args")
	dump(deepLinking.splitTheArgList(args.argList), "args")
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Instagram-Reengagement"
;(nil).param = "Re-Engagement-Online"
_ENV, (nil)[5], (nil).work = nil, nil, function(...)
	print("不做事 记录INS连接进来的")
	local args = (...)
	deepLinking.log2server(args.host, args.param, "", args.argList)
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Google-Reengagement"
;(nil).param = "Re-Engagement-Online"
_ENV, (nil)[6], (nil).work = nil, nil, function(...)
	print("不做事 记录GOOGLE连接进来的")
	local args = (...)
	deepLinking.log2server(args.host, args.param, "", args.argList)
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Twitter-Reengagement"
;(nil).param = "Re-Engagement-Online"
_ENV, (nil)[7], (nil).work = nil, nil, function(...)
	print("不做事 记录Twitter连接进来的")
	local args = (...)
	deepLinking.log2server(args.host, args.param, "", args.argList)
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "kochava"
;(nil).param = "gotoStore"
_ENV, (nil)[8], (nil).work = nil, nil, function(...)
	print("不做事 ko跳转充值商城")
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
	local args = (...)
	deepLinking.log2server(args.host, args.param, "", args.argList)
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "3dtouch"
;(nil).param = "openMail"
_ENV, (nil)[9], (nil).work = nil, nil, function(...)
	local gametop = gModuleMgr.getObject("gametop")
	if gametop and SoraDIsGameGuide() == nil then
		local mailView = SoraDCreatePanel("mailView")
		mailView:show()
		mailView:initWithData(nil)
	end
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "3dtouch"
;(nil).param = "openChat"
_ENV, (nil)[10], (nil).work = nil, nil, function(...)
	local gametop = gModuleMgr.getObject("gametop")
	if not gametop or SoraDIsGameGuide() == nil then
	end
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "3dtouch"
;(nil).param = "openAllianceWar"
_ENV, (nil)[11], (nil).work = nil, nil, function(...)
	local gametop = gModuleMgr.getObject("gametop")
	if not gametop or SoraDIsGameGuide() == nil then
	end
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Snapchat-Reengagement"
;(nil).param = "Re-Engagement-Online"
_ENV, (nil)[12], (nil).work = nil, nil, function(...)
	print("不做事 记录Snapchat连接进来的")
	local args = (...)
	deepLinking.log2server(args.host, args.param, "", args.argList)
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "RTB_House"
;(nil).param = "gotoStore"
_ENV, (nil)[13], (nil).work = nil, nil, gotostore_work
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Facebook_Recharge"
;(nil).param = "gotoStore"
_ENV, (nil)[14], (nil).work = nil, nil, gotostore_work
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Google_Recharge"
;(nil).param = "gotoStore"
_ENV, (nil)[15], (nil).work = nil, nil, gotostore_work
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "RTB_House"
;(nil).param = "Re-Engagement-Online"
_ENV, (nil)[16], (nil).work = nil, nil, log_work
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Facebook_Recharge"
;(nil).param = "Re-Engagement-Online"
_ENV, (nil)[17], (nil).work = nil, nil, log_work
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Google_Recharge"
;(nil).param = "Re-Engagement-Online"
_ENV, (nil)[18], (nil).work = nil, nil, log_work
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "Sultan_CallBack"
;(nil).param = "openSultanActivity"
_ENV, (nil)[19], (nil).work = nil, nil, function(...)
	local args = (...)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY) then
		uiManager:show("NewStart")
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY)
	end
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "ActivityJump"
;(nil).param = "openAnniversaryActivity"
_ENV, (nil)[20], (nil).work = nil, nil, function(...)
end
;(nil).scheme = "onemt-ros-ar"
;(nil).host = "HeroJump"
;(nil).param = "openHeroDetailViewPanel"
;(nil)[21], (nil).work = nil, function(...)
	local args = (...)
	local argList = deepLinking.splitTheArgList(args.argList)
	SoraDShowHeroDetailView(tonumber(argList.heroID))
end
local DEEPLINKINGCONF
return DEEPLINKINGCONF
