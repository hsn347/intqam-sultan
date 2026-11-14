local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local _ENV, msgNotice = "backpackltCtrl", "backpackltCtrl"
function msgNotice.rspNotice(rsp)
	local err = tostring(rsp.err)
	if gErrDef.Err_SERVICE_EXCEPTION == err then
		SoraDShowMsgTip("service exception!")
		dump(rsp, "service exception!", 10)
	end
	local notice_id = msgNotice.getTipCode(err)
	if notice_id then
		dump(rsp, "msgNotice.rspNotice====", 10)
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			print("notice_id =", err, notice_id)
			_ENV = "notice_id ="
			;("notice_id =").msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;("notice_id =").messageID = notice_id
			SoraDSendMessage("notice_id =")
		elseif "function" == type(fun) then
			fun(notice_id, rsp)
		end
	else
	end
end
_ENV, msgNotice.notice = function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end, function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ILLEGAL_PARAMS] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ACTIVITY_TEST] = "brightWar_text_151"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KINGDOM_NOT_MEET] = "common_text_3302"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NOT_IN_THIS_KINGDOM] = "common_text_2413"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_NO_PERMISSION] = "notice_0205"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_NOT_FOUND] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_POS_CHANGE] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_EXPLORE_TIMEOUT] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_FULL] = "notice_0023"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_ARMY_DATA_ERROR] = "notice_0027"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_ARMY_EMPTY] = "notice_0027"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_RELICS_NO_TARGET] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_RELICS_TIME_NOT_ENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_ARMY_NOT_ENOUGH] = "notice_0027"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CANNOT_BACK] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_MOVING] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_SAME_ALLIANCE] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_NOT_ATTACK_SELF] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_EMBASSY_LEVEL_LESS] = "notice_0069"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_ARMP_HELPER_NEED_SAME_ALLIANCE] = "notice_0172"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_HAS_ARMP_HELPER] = "common_text_704"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_ARMY_HELPER_NUM_OUT] = "notice_0161"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MARKET_LEVEL_LESS] = "notice_0068"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_RESOURCE_HELP_NEED_SAME_ALLIANCE] = "notice_0078"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_RESOURCE_HELP_RESOURCE_NOT_OPEN] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_RESOURCE_HELP_WEIGHT_OUT] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_RESOURCE_NOT_ENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_STATUS_CHANGE] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_SLAVE_EXIST] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_CREATOR_CANNOT_IN] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_CANNOT_SAME_PLAYER] = "notice_0147"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_NPC_LEVEL_OUT] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_NOT_SELF] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_TYPE_ERROR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_STATUS_ERROR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_NUM_OUT] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_PHY_NOT_ENGHOUT] = "common_text_988"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_PLAYER_NOT_FOUND] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CAMP_NOT_EXIST] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_BATTLE_NUM_OUT] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_BATTLE_FAIL] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_RELICS_ONE_TIME] = "notice_0039"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CANNOT_SPEED] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_ITEM_ERROR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CANNOT_RECALL] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_COLL_IRON_CASTLE_LEVEL_LESS] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_COLL_MITHRIL_CASTLE_LEVEL_LESS] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_CASTLE_LEVEL_LESS] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_RESOURCE_HELPER_NEED_SAME_ALLIANCE] = "notice_0078"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_CHEST_HAS_COLL] = "notice_0180"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_SELF_HAS_GUARD_ALLIANCE_BUILD] = "notice_0197"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CANT_ATTACK_ALLIANCE_FORT] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_ALLIANCE_BUILD_ALREADY] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CANT_ATTACK_ALLY] = "notice_0198"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CANT_SCOUT_ALLY] = "notice_0198"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_KING_WAR_STATUS_ERROR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MOVE_CITY_NOT_PLAIN] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_RANDOM_MOVE_CITY_FAIL] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_RANDOM_MOVE_CITY_HAS_QUEUE] = "notice_0033"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_RANDOM_MOVE_CITY_HAS_OTHER_2_SELF_QUEUE] = "notice_0034"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_RANDOM_MOVE_CITY_DANGER] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_RANDOM_MOVE_CITY_HAS_MASS_QUEUE] = "notice_0148"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_TERR_MOVE_CITY_FORBIDDEN] = "common_text_3111"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MANU_PLACE_BOSS_NUM_ERROR] = "common_text_2987"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_LLW_REACH_PLAYER_LIMIT] = "legendaryking_text_19"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_LLW_COLSE_MOVE_IN] = "legendaryking_text_19"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MOVE_CITY_NOT_IN_WAR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MOVE_CITY_CD] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MOVE_2_OTHER_KINGDOM_TIMEOUT] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MOVE_2_OTHER_KINGDOM_RES_OUT] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MOVE_2_OTHER_KINGDOM_SERVICE_WAR_NOT_OPEN] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_SPEED_QUEUE_LOCKED] = "remains_text_364"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_LLW_FOR_SEP_REACH_PLAYER_LIMIT] = "kingstarbattle_text_04"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_LLW_FOR_SEP_COLSE_MOVE_IN] = "kingstarbattle_text_04"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MOVE_CITY_NEW_PLAYER_SWITCH] = "common_text_4958"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MOVE_CITY_CONQUEST_BLACK_LAND_STAR_LV] = "common_text_4959"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ITEM_IS_NOT_ENOUGH] = "notice_0120"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ITEM_USE_COUNT_IS_LIMIT] = "notice_0121"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CASTLE_LEVEL_IS_NOT_REACHED] = "notice_0122"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_LORD_LEVEL_IS_NOT_REACHED] = "notice_0123"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NOT_BUILD_WISHING_WELL] = "notice_0167"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_BACKPACK_IS_FULL] = "notice_0119"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NOT_FOUND_USER] = "notice_0096"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAIL_SENDER_IN_BLACKLIST] = "notice_0097"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAIL_NOT_GET_EXTRA] = "notice_0099"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAIL_ALREADY_LOCK] = "notice_0101"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_NOT_FREQUENT_SEND_EXPRESSION] = "notice_0094"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_KINGDOM_NOT_FREQUENT_SEND_EXPRESSION] = "notice_0094"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_KINGDOM_NOT_FREQUENT_SEND_CONTENT] = "notice_0095"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_NOT_FREQUENT_SEND_CONTENT] = "notice_0095"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHAT_BAN] = "common_text_1039"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NICKNAME_MIN_SIZE] = "notice_0109"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER] = "notice_0110"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAIL_SENDER_IN_BLACKLIST] = "notice_0097"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAIL_NOT_GET_EXTRA] = "notice_0099"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAIL_ALREADY_LOCK] = "notice_0101"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAIL_COLLECT_LIMIT] = "mail_2_text_16"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SHARE_FREQUENTLY] = "notice_0104"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ITEM_CANNOT_GIVE] = "notice_0105"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_GIVE_ITEM_IS_NOT_ENOUGH] = "notice_0107"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_LEGEND_LORD_POINT_NOT_ENOUGTH] = "tips_exchange_point_noEnough"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_APPLICATION_INVALID] = "notice_0091"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_SCIENCE_LOCK] = "notice_0081"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_NAME_ILLEGAL] = "notice_0071"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ABBR_ILLEGAL] = "notice_0071"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MANIFESTO_ILLEGAL] = "notice_0071"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RANKNAME_ILLEGAL] = "notice_0071"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MSG_ILLEGAL] = "notice_0071"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ONLY_HELP_SAME_ALLIANCE] = "notice_0162"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_NOT_PUBLIC_RECRUIT] = "notice_0163"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MEMBER_FULL] = "notice_0171"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_NAME_LENGTH] = "notice_0070"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ABBR_LENGTH] = "notice_0074"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANE_ABBR_HAVE] = "notice_0155"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_NO_PERMISSION] = "common_text_203"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ABBR_ILLEGAL] = "notice_0154"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MSG_LENGTH] = "notice_0084"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MSG_AID_IN_SHIELDLIST] = "notice_0174"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MSG_UID_IN_SHIELDLIST] = "common_text_2767"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_NOTMATCH_RECRUIT_CONDITION] = "common_text_1159"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_SCORE_NOT_ENOUGH] = "common_text_273"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_BWLIST_NOT_FOUND] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ALREADY_IN_BLACK_LIST] = "notice_0182"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ALREADY_IN_WHITE_LIST] = "notice_0183"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_BUILDING_EXIST] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_BUILDING_NOT_EXIST] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_POWER_NOT_ENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MEM_COUNT_NOT_ENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_NOT_EXIST] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_IS_ALLY_ALREADY] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_IS_FRIENDLY_ALREADY] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_IS_ENEMY_ALREADY] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_IS_NEUTRALITY_ALREADY] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_ALLY_NUM_REACH_MAX] = "notice_0199"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_OTHER_ALLY_NUM_REACH_MAX] = "notice_0200"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_INVITE_SEND_NUM_REACH_MAX] = "notice_0201"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_INVITE_OTHER_RECV_NUM_REACH_MAX] = "notice_0202"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_INVITE_SEND_ALREADY] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_INVITE_SEND_REJECTED_PERIOD] = "common_text_3087"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_SINGLE_ALTER_REACH_DAY_MAX] = "common_text_3091"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RELATION_TOTAL_ALTER_REACH_DAY_MAX] = "common_text_3091"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_JOIN_LESS_ONE_DAY] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_BUILDING_NEED_NOT_RESTORE] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ALLOCATE_RESOUSE_NOT_ENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_BUILD_NOT_ON_PLAIN] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_BUILD_TOUCH_BLACK_LAND] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_BUILD_TOUCH_OTHER_ALLIANCE] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_BUILD_NOT_CONNECT_AREA] = "alliance_stronghold_text_122"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_CANNOT_EXIT_HAS_ATK_ALLIANCE_BUILD_QUEUE] = "notice_0203"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_SCIENCE_RECOMMEND_LIMIT] = "alliance_text_05"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_SCIENCE_REPEAT_RECOMMEND] = "alliance_text_06"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_SCIENCE_MAX] = "alliance_text_08"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_SCIENCE_RECOMMEND_NOT_FOUND] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ALEADY_JOIN] = "alliance_join_tips_01"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_NOT_JOIN_ALLIANCE] = "common_text_583"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_ABNORMAL_REQ_ADD_QUEUE] = "alliance_beast_notice_09"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_BEAST_ALREADY_EXIST] = "alliance_beast_notice_08"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_CANNOT_DISMISS_KW_BUILDING_OWNER] = "alliance_text_20"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_CANNOT_DISMISS_KW_TOP_SCORE] = "alliance_text_19"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CANT_ATTACK_ALLY_MAPOBJ] = "brightWar_text_203"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CANT_MASS_SAME_KINGDOM_PLAYER_CONQUESTWAR] = "common_text_4576"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_CANT_ATTACK_CONQUESWAR_CLOSE] = "tips_acrossWarTimeOut_atkLimit"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_TERRITORY_NEAR_STRONGHOLD] = "alliance_stronghold_text_137"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RESOUCH_NOT_REACH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_GOLD_NOT_REACH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RECHARGE_TRANSACTION_DATA_EXCEPTION] = "notice_0164"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RECHARGE_DAYBUY_COMPLETE] = "notice_0165"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RECHARGE_ONLYONE_COMPLETE] = "notice_0166"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RECHARGE_ACTIVITY_MONTH_GIFT_NOTEFFECT] = "notice_0013"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RECHARGE_ACTIVITY_MONTH_GIFT_DAYGET] = "notice_0014"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ROME_ACTIVITY_IS_RUNNING] = "common_text_1511"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_HT_VIP_CONDITION_NOT_ENOUGH] = "common_text_1804"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_HT_REPEAT_TO_AUTO_TRIAL] = "herotried_text_01"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WALLS_MAX_DEFENCE] = "notice_0181"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_GROUPBUY_ACTIVITY_CLOSE] = "notice_0188"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_GROUPBUY_ALLEADY_BUY] = "notice_0189"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SHOPITEM_IS_INVALID] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_BADGE_EXCHANGE_MOST_LIMIT] = "common_text_1947"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_EQUIPMENT_NUM_MAX] = "notice_0119"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CONQUESTWAR_ALLIANCE_MEMBER_IN_ENEMY_KINGDOM] = "common_text_3302"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MEMBER_IN_CONQUESTWAR] = "common_text_2167"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TARGET_PLAYER_NOT_CUR_KINGDOM] = "common_text_2168"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CONQUESTWAR_ALLIANCE_LEADER_NOT_IN_CUR_KINGDOM] = "common_text_2173"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_RANDOM_MOVE_CITY_NOT_IN_BLACK_LAND] = "common_text_2257"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_ESCORT_ADD_OPEN_ERROR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ESCORT_OTHER_REACH_ROBBED_LIMIT] = "common_text_2356"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ESCORT_SELF_REACH_ROB_LIMIT] = "common_text_2354"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_KW_NAME_IN_OTHER_KINGDOM] = "common_text_2168"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ESCORT_ASSIST_INVITE_TIMEOUT] = "common_text_992"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NO_DEADARMY] = "common_text_2504"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TOOLS_NOT_REACH] = "common_text_2512"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_TREASUR_BOWL_NOT_FOUND] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_TREASUR_BOWL_REACH_LIMIT] = "common_text_3546"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_TREASUR_BOWL_SOMEONE_CLICK] = "common_text_3543"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_TREASUR_BOWL_SOMEONE_CLICK_LACK] = "common_text_3542"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_TREASUR_BOWL_BACK_ITEM] = "common_text_3633"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_RESOURCE_HELP_OUT_ONE_DAY] = "common_text_2565"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_MOVE_CITY_TIMES_FULL] = "common_text_3386"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_FORBIT_WAR_TIME] = "common_text_3445"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SNATCH_ACTIVITY_STATE_ERROR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SNATCH_ACTIVITY_LEFTTICKET_ERROR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_KINGDOMWAR_HANDLEREWARD] = "common_text_2692"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_QUICK_SEARCH_MONSTER_TIME_QUEUE_LOCK] = "common_text_2863"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_UNLOCK_ERROR_PET_EXIST] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_UNLOCK_ERROR_DEBRIS_COUNT_NOTENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_UNLOCK_ERROR_CASTLELV_NOTENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_UNLOCK_ERROR_LORDLV_NOTENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_UNLOCK_ERROR_KILL_NOTENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_DEBRISID_NOT_FIND] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_PETID_NOT_FIND] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_OBJ_NOT_FIND] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_FEED_TYPE_ERROR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_FEED_ERROR_MAXLV] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_FEED_FREE_MAX] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_FEED_GOLD_MAX] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_FEED_TOOL_DEBRIS_NOTMATCH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_FEED_TOOL_ERROR] = "common_text_2512"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_ADVANCE_TYPE_ERROR] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_FEED_TOOL_ADDEXP_MAX] = "common_text_2958"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_ADVANE_NOT_REACH] = "common_text_2959"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_ADVANCE_MAX_RANK] = "common_text_2960"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_SHARE_ERROR_CDTIME] = "common_text_2961"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_SPECIAL_SKILL_SEND_NOT_ACTIVATE] = "common_text_2962"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PET_SPECIAL_SKILL_SEND_IN_CDTIME] = "common_text_2963"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_JOIN_ERROR_BEING_ALLIANCE_ATK] = "common_text_3098"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_JOIN_ERROR_BEING_ALLIANCE_MASS] = "common_text_3099"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_AGREE_ERROR_BEING_ALLIANCE_ATK] = "common_text_3100"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_AGREE_ERROR_BEING_ALLIANCE_MASS] = "common_text_3101"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_AGREE_ERROR_ATK_ALLIANCE] = "common_text_3266"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_JOIN_ERROR_ATK_ALLIANCE_MEM] = "common_text_3297"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SIEGE_COMBAT_CHECK_ERROR] = "common_text_154"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SIEGE_COMBAT_CHECK_STEPS_ERROR] = "common_text_154"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_APPLY_PERMISSION] = "common_text_3252"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_APPLY_CREATETIME] = "common_text_3253"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_APPLY_AID_RANK_ERROR] = "common_text_3254"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_APPLY_AID_APPLYED] = "common_text_3255"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_APPLY_NUM_FULL] = "common_text_3256"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_APPOINT_MEM_JOINTIME_ERR] = "common_text_3257"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_APPOINT_MEM_CITYLV_ERR] = "common_text_3258"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_APPOINT_MEM_MAX_ERR] = "common_text_3259"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_ENTER_NO_APPOINT] = "common_text_3260"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_ENTER_HAVE_WOUNDEDARMY] = "common_text_3261"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_ENTER_HAVE_MASS_QUEUE] = "common_text_3262"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_CANNOT_DISMISS_PYRAMIDWAR_RUNNING] = "common_text_3299"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_PLAYER_NOT_IN_ALLIANCE] = "common_text_4453"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_APPLY_STATE_ERROR] = "notice_0038"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_APPOINT_ALLIANCE_STATE_ERR] = "notice_0038"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_APPOINT_MEM_STATE_ERR] = "notice_0038"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_APPOINT_CANCEL_MEM_STATE_ERR] = "notice_0038"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_REGULAR_SEASON_ENTER_ARMY_QUEUE_HAVE_WOUNDEDARMY] = "common_text_3498"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_POST_SEASON_APPLY_STATE_ERROR] = "notice_0038"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_POST_SEASON_APPLY_PERMISSION] = "common_text_4003"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_POST_SEASON_APPLY_AID_NOT_FOUND] = "notice_0038"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_POST_SEASON_APPLY_AID_APPLYED] = "notice_0038"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_NOT_OPEN] = "notice_0038"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_POST_SEASON_GIFT_NOT_TOP] = "notice_0038"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_CANNOT_DISMISS_POST_SEASON_RUNNING] = "common_text_4081"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_POST_SEASON_GIFT_INTIME] = "common_text_4082"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PYRAMIDWAR_ALREADY_JOIN_BATTLE_ERR] = "common_text_4383"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_LLW_BLACK_LAND_CAN_NOT_OPEN_SHIELD] = "common_text_4261"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_LL_IN_APPOINT_CD] = "legendaryking_text_15"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_LL_KINGDOM_NOT_JOIN_ACT] = "legendaryking_text_16"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_LL_KINGDOM_OF_USER_NOT_JOIN_ACT] = "legendaryking_text_17"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_LH_IN_APPOINT_CD] = "legendaryking_text_15"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_KINGDOMWAR_ALLIANCE_WIN] = "CombineServers_60"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WORLD_CUP_ACTIVITY_GUESSGOAL_ERR] = "worldcup_notice_05"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WORLD_CUP_ACTIVITY_ITEM_NOT_ENOUGH] = "notice_0120"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WORLD_CUP_ACTIVITY_GUESS_STATUS_ERR] = "worldcup_notice_07"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WORLD_CUP_ACTIVITY_ALREADY_GUESS] = "worldcup_notice_08"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WORLD_CUP_ACTIVITY_CHEER_TEAM_NOT_SAME] = "worldcup_notice_02"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WORLD_CUP_ACTIVITY_CHEER_REACH_LIMIT] = "worldcup_notice_03"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MOVE_OTHER_KINGDOM_ACTIVITY_ALLIANCE_LEADER] = "migrate_notice_02"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MOVE_OTHER_KINGDOM_ACTIVITY_IN_ALLIANCE] = "migrate_notice_03"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEW_KING_FUND_NOT_OPEN] = "common_text_2486"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEW_KING_FUND_ALREADY_INVEST] = "new_lord_fund_text_05"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARTY_PARTY_IS_END] = "feast_tips_13"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARTY_NOT_FOUND_PARTY] = "feast_tips_13"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARTY_NOT_ENOUGH_COUNT] = "feast_tips_02"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARTY_LIMIT_COUNT] = "feast_tips_14"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARTY_SELF_CREATE_PARTY] = "feast_tips_20"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARTY_INVITE_TOO_OFTEN] = "feast_tips_09"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARTY_CAN_NOT_SEAT] = "feast_tips_12"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARTY_NOT_OPEN_ACTIVITY] = "feast_tips_01"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_NOT_IN_MATCH_STATE] = "remains_text_14"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_NOT_JOIN_ALLIANCE] = "remains_text_15"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_TEAM_NAME_ILLEGAL] = "remains_text_139"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_TEAM_NAME_HAVE] = "remains_text_140"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_TEAM_BATTLE_TIMES] = "remains_text_21"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_EMPTY_ARMY] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_ARMY_NOT_ENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_TEAM_NOT_FOUND] = "remains_text_147"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_NOT_SAME_ALLIANCE] = "remains_text_19"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_FULL_TEAM] = "remains_text_22"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_TEAM_STATE_ERR] = "remains_text_23"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_PLAYER_NOT_IN_TEAM] = "remains_text_38"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_HAVE_TEAM] = "remains_text_309"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_IS_TEAM_LEADER] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_PLAYER_IS_IN_TEAM] = "remains_text_52"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_HAS_INVITE] = "remains_text_152"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_MEMBER_NOT_ENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_TEAM_NOT_MATCH] = "remains_text_61"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_NOT_IN_BATTLE_STATE] = "remains_text_62"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_HAVE_WOUNDEDARMY] = "remains_text_63"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_HAS_MASS_QUEUE] = "remains_text_64"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_PLAYER_NOT_APPLY] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_QUIT_BATTLE_FAIL] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_TEAM_NAME_LENGTH] = "remains_text_150"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MEMBER_HAS_RUINS_WAR_TEAM] = "remains_text_127"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_ALREADY_SHARED] = "remains_text_149"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_SHARE_ERROR_CDTIME] = "remains_text_149"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ACTIVITY_NOT_START] = "common_text_2486"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_SHARE_HISTORY_CDTIME] = "common_text_046"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_NOT_SAME_GROUP] = "common_text_4941"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_BE_BANNED] = "remains_text_373"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RUINS_WAR_BOSS_SKILL_NOT_ENOUGH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_FROM_RW_CAMP_RANGE] = "remains_text_142"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_TO_RW_CAMP_RANGE] = "remains_text_158"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NOT_FOUND_TEAM] = "remains_text_147"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_MEMBER_FULL] = "remains_text_22"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_APPLY_INVALID] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_IN_TEAM] = "remains_text_309"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NOT_IN_TEAM] = "remains_text_38"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_ALREADY_IS_MEMBER] = "remains_text_52"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_LOCK] = "remains_text_23"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_REPEAT_INVITE] = "remains_text_152"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_REPEAT_APPLY] = "alliance_office_text_16"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_NOT_IN_SELF_KID] = "common_text_3302"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_TARGET_NOT_IN_SELF_KID] = "common_text_3400"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_KINGDOM_NOT_JOIN_ACT] = "free_team_text_85"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_NOT_SAME_HEGMON_STATUE] = "free_team_text_24"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TEAM_DISMISS_HAS_MEMBER] = "nebula_war_text_0029"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHRISTMAS_BATTLE_EXCHANGE_LIMIT] = "christmas_stocking_tips_03"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHRISTMAS_BATTLE_SOCKS_NOT_ENOUGH] = "christmas_stocking_tips_02"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHRISTMAS_BATTLE_FAVOR_GIFT_GET] = "christmas_stocking_tips_05"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHRISTMAS_BATTLE_FAVOR_NOT_ENOUGH] = "christmas_stocking_tips_06"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHRISTMAS_TREE_ITEM_NOT_ENOUGH] = "christmas_tree_tips_01"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHRISTMAS_TREE_HAS_COLL] = "christmas_tree_tips_04"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHRISTMAS_TREE_COLL_TIMES_OUT] = "christmas_tree_tips_05"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHRISTMAS_TREE_PLANT_TIMES_OUT] = "christmas_tree_tips_06"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_NOT_OPEN_ACTIVITY] = "common_text_2486"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_JOIN_ALLIANCE_TOO_LATE] = "devilvalley_tips_03"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_NOT_FOUND_TEAM] = "remains_text_147"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_MEMBER_IS_FULL] = "remains_text_22"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_CAN_NOT_QUIT_ALLIANCE] = "devilvalley_tips_10"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_CAN_NOT_KICKOUT_ALLIANCE] = "devilvalley_tips_11"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_FAST_START_FAIL] = "devilvalley_text_13"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_NOT_ENOUGH_BUY_COUNT] = "Secret_explore_notice_13"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_CASTLE_LV_NOT_ENOUGH] = "devilvalley_tips_01"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_CHALLENGE_LV_ERR] = "devilvalley_tips_02"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_IS_ALREADY_IN_TEAM] = "devilvalley_tips_04"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_NOT_HAVE_ALLIANCE] = "common_text_583"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_CREATE_COUNT_LIMIT] = "common_text_2538"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_ALREADY_START] = "devilvalley_text_44"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ANNIVERSARY_NOT_FIND_TASK] = "celebration_text_08"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ANNIVERSARY_NOT_COMPLETE] = "celebration_text_09"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ANNIVERSARY_ACTIVITY_CLOSE] = "common_text_2486"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ANNIVERSARY_NOT_BUG_DAY] = "celebration_text_10"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ANNIVERSARY_CANNT_BUY] = "celebration_text_11"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ANNIVERSARY_CASTLE_LEVEL_LIMIT] = "celebration_text_12"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ANNIVERSARY_NOTHING_TO_GET] = "celebration_text_04"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DAILY_DISCOUNT_ACTIVITY_CLOSE] = "common_text_2486"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DAILY_DISCOUNT_ALREADY_RECEIVE] = "common_text_1892"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DAILY_DISCOUNT_GIFT_LESS_THAN_3] = "weekly_sale_text_07"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WEEKLY_DISCOUNT_ACTIVITY_CLOSE] = "common_text_2486"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WEEKLY_DISCOUNT_ALREADY_RECEIVE] = "common_text_1892"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WEEKLY_DISCOUNT_GIFT_LESS_THAN_3] = "weekly_sale_text_07"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_TREASURE_PLEASE_RECEIVE_FIRST] = "alliance_treasure_tip_01"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DEVIL_VALLEY_START_FAIL] = "devilvalley_btn_13"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SHARE_AREADY_RECEIVED] = "common_text_1892"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SALES_ROOM_NEW_PRICE_ERROR] = "common_text_2834"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SALES_ROOM_ITEM_INFO_ERROR] = "common_text_2835"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SALES_ROOM_PLUS_NOT_ENOUGH] = "common_text_2834"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_NOT_IN_ORIGINAL_KINGDOM] = "common_text_3400"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_REQ_IN_CD] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_TEXT_ILLEGAL_CHARACTER] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_OFFICIAL_NOT_MATCH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_OFFICIAL_CAN_NOT_TRICK] = "parliament_text_27"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_POLICY_ALREADY_EXECUTE] = "parliament_text_56"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_POLICY_ALREADY_PROMISE] = "parliament_text_41"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_RECALL_OFFICIAL_IN_EFFECT] = "parliament_text_63"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_MONITOR_EMBEZZLE_IN_EFFECT] = "parliament_text_65"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_PLAYER_LONGER_PEACE_SHIELD] = "parliament_text_77"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_TREASURY_RESOURCE_NOT_REACH] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_RESOURCE_IS_FULL] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_PLAYER_PRISON_EXIST_HERO] = "parliament_text_137"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_PARLIAMENT_CAN_NOT_RECALL_OFFICIAL_IN_CONQUESTWAR] = "parliament_text_144"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ENDLESS_TRIALS_BOSS_NOT_FIND] = "Endless_trial_text_10"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WAR_TREASURE_COLL_ONE_TIME] = "warSecrit_text_16"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DUEL_IN_CD] = "lordskill_text_13"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DUEL_SOLDIER_NOT_ENOUGH] = "lordskill_text_10"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DUEL_CASTLE_LEVEL] = "lordskill_text_11"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DUEL_RESIST] = "lordskill_text_13"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_STATE_ERR] = "notice_0011"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_NOT_IN_SELF_KINGDOM] = "common_text_3385"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_NOT_MATCH_SUCCESS] = "remains_text_61"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_NOT_JOIN_ALLIANCE] = "common_text_826"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_PLAYER_HAS_QUEUE] = "brightWar_text_122"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_PLAYER_BEING_ATTACKED] = "brightWar_text_09"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_ENTER_BATTLEFIELD_FAIL] = "notice_0011"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_QUIT_BATTLEFIELD_FAIL] = "notice_0011"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_CASTLE_LEVEL] = "remains_text_20"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_NOT_IN_BATTLEFIELD] = "remains_text_304"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_RES_NOT_BELONG_TO_PLAYER] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_IN_PEACE] = "brightWar_text_124"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_REACH_PLAYER_LIMIT] = "brightWar_text_125"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_REACH_RES_LIMIT] = "brightWar_text_54"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_REACH_BEACON_LIMIT] = "brightWar_text_53"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RADIANCE_WOUNDED_ARMY_DISMISS] = "brightWar_text_120"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RADIANCE_WOUNDED_ARMY_KICK] = "brightWar_text_121"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_RADIANCE_WOUNDED_ARMY_QUIT] = "brightWar_text_05"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_WALLS_IS_BURNING] = "brightWar_text_150"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_BUILD_CAN_NOT_OCCUPY] = "brightWar_text_129"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_AMBER_POINT_NOT_ENOUGH] = "brightWar_text_169"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_AMBER_POINT_REACH_LIMIT] = "brightWar_text_170"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_RES_BEACON_NOT_OCCUPY] = "brightWar_text_80"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ANN_CAMPFIRE_ALLIANCE_QUIT] = "anniversary_fire_text_28"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ANN_CAMPFIRE_ALLIANCE_KICKOUT] = "anniversary_fire_text_38"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ANN_CAMPFIRE_QUEUE_FULL] = "anniversary_fire_text_27"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ANN_CAMPFIRE_BUILD_FAIL] = "anniversary_fire_text_05"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ACTIVITY_TEAM_HAS_TEAM] = "togetherTeam_text_06"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ACTIVITY_TEAM_NOT_EXIST_TEAM] = "togetherTeam_text_37"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TOGETHER_TEAM_DIFF_KINGDOM] = "togetherTeam_text_11"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TOGETHER_TEAM_NOT_FRIEND_OR_NOT_ALLAIANCE] = "togetherTeam_text_46"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ACTIVITY_TEAM_ALREADY_IN_TEAM] = "togetherTeam_text_64"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TOGETHER_TEAM_HAS_ACCEPT] = "togetherTeam_text_41"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ACTIVITY_TEAM_HAS_INVITED] = "togetherTeam_text_44"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_TOGETHER_TEAM_NOT_HAS_START_GAME] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SULTAN_BACK_REBATE_NOT_OPEN] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SULTAN_BACK_REBATE_NOT_FOUND_REWARD] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SULTAN_BACK_REBATE_ALREADY_RECEIVE] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SULTAN_BACK_REBATE_CAN_NOT_RECEIVE] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SULTAN_BACK_REBATE_BUY_LIMIT] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_SULTAN_BACK_REBATE_NO_BUY_PERMISSION] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ICESNOW_WONDER_NOTEXIST] = "ice_carnival_text_06"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ICESNOW_WONDER_BUSY] = "ice_carnival_text_09"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ICESNOW_WONDER_DAYMAX] = "ice_carnival_text_08"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ICESNOW_WONDER_LOCKED] = "ice_carnival_text_09"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ICESNOW_WONDER_FAIL_COUNT] = "ice_carnival_text_14"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ICESNOW_WONDER_FAIL_TIME] = "ice_carnival_text_14"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_ICESNOW_WONDER_ITEM_NOTENOUGH] = "ice_carnival_text_07"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_SERRIS_SHOP_RECHARGED] = "serica_text_09"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_SERRIS_SHOP_RECHARGED_NOT_EXIST] = "serica_text_11"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_SERRIS_SHOP_RECHARGED_EXCEPTION] = "serica_text_12"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RAMADAN_FEAST_REMAIN_LESS_300] = "tips_feast_toDinnerTime_limit"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RAMADAN_FEAST_FINISH_FEAST] = "tips_feast_toDinner_complete"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_MOVE_CD] = "tips_acs_invitation_moveCD"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_PLAYER_STRENGTH_LIMIT] = "tips_acs_move_overPower"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_KINGDOM_MOVE_STRENGTH_LIMIT] = "tips_across_over_serverPower"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_CLOSE_MOVE_IN] = "tips_across_wayClosed"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_PLAYER_HAS_QUEUE] = "tips_across_troopNoBack"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_PLAYER_BEING_ATTACKED] = "tips_across_inWar"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_CANT_CARRY_ALLIANCE] = "tips_across_unionLimit"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_CANT_CARRY_TEAM] = "tips_across_warTeamNotDismiss"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_KING_WAR] = "tips_across_kingwar_limit"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_CONQUEST_WAR] = "tips_across_wgzfz_limit"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_LEGEND_LORD_WAR] = "tips_across_cqjw_limit"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_LEGEND_HEGEMON_WAR] = "tips_across_cqbz_limit"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_SEND_INVITE_CD] = "tips_acs_invitationCD"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_SEND_INVITE_LIMIT] = "tips_across_invitationNumMax"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_PLAYER_ALREADY_MOVE] = "common_text_3400"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_NOT_REACH_PLAYER_STRENGTH_LIMIT] = "tips_apply_lessPower"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_NOT_KING] = "tips_across_kingPowerLimit"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_ATLANTIS_WAR] = "atlantiswar_text_0258"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_NEBULA_WAR] = "atlantiswar_text_0258"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_RUINS_WAR] = "atlantiswar_text_0258"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_LEGEND_LORD_FOR_SEP_WAR] = "kingstarbattle_text_77"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_SEEDED_PLAYER_COUNT_LIMIT] = "across_move_text_0022"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_IN_NEBULA_EMPEROR_WAR] = "nebulaemperor_text_194"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_SELF_NEW_KINGDOM] = "migrant_move_text48"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.ERR_KOH_MIGRATE_NEBULA_REGION_SEASON_LIMIT] = "migrant_move_text51"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_COUNTER_SYSTEM_NOT_SAME_KINGDOM] = "common_text_3400"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ATLANTIS_WAR_STATE_ERR] = "privilege_text_85"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ATLANTIS_WAR_TEAM_ALREADY_MASS_BOSS] = "atlantiswar_text_0087"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ATLANTIS_WAR_NOT_ARMY] = "common_text_1415"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ATLANTIS_WAR_NOT_MATCH_SUCCESS] = "remains_text_61"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_OCCUPY_ARMY_LEVEL_LIMIT] = "atlantiswar_text_0300"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MARK_NO_ALLIANCE] = "common_text_826"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MARK_NO_PRIVILEGE] = "alliance_store_returns_description_5"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_MARK_ILLEGAL_MAPID] = "alliance_mapmark_text_014"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ARTIFACT_ARRIVE_NOT_IN_SELF_KINGDOM] = "togetherTeam_text_11"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ARTIFACT_ARRIVE_PUT_FAIL] = "artifact_befall_text_06"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ARTIFACT_ARRIVE_NO_PLACE_TO_PUT] = "artifact_befall_text_01"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CHATROOM_SELF_NOT_IN_CHATROOM] = "common_text_2213"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_STAR_TREASURE_EXPLORE_ALREADY_SCOUT] = "ramadanTreasure_text09"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_DAY_ILLEGAL] = "notice_0026"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_NOT_ENOUGH_GOLD] = "common_text_423"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_SIGN_ALREADY_RECEIVE] = "common_text_1892"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_SIGN_NOT_FOUND_REWARD] = "celebration_text_04"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_NOT_ENOUGH_LV] = "remains_text_20"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_NOT_IN_SELF_KID] = "common_text_3385"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_WAR_MINE_NOT_BELONG_SELF_CAMP] = "nebula_war_text_0289"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_WAR_MINE_BELONG_OTHER_TEAM] = "nebula_war_text_0288"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_WAR_BUILD_NOT_CONNECT] = "nebula_war_text_0343"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_WAR_BUILD_OCCUPY_BY_SAME_CAMP] = "nebula_war_text_0344"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_WAR_BUILD_IN_PROTECTED] = "nebula_war_text_0345"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_COMMAND_HALL_QUEUE_STATUE_ERROR] = "commandhall_text_65"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DIVINE_BEAST_CANYON_MAX_BUY_TIMES] = "Divinebeastcanyon_text_17"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_EXCHANGE_NOT_ENOUGH_DIVINE_BEAST_LV] = "Divinebeastcanyon_text_28"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CONQUESTWAR_TARGET_IS_KING] = "conquestwar_text_43"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CONQUESTWAR_INVITED_NUM_LIMIT] = "conquestwar_text_37"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CONQUESTWAR_NOT_KING] = "conquestwar_text_36"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CONQUESTWAR_NOT_REINFORCEMENTS_KINGDOM] = "conquestwar_text_39"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CONQUESTWAR_INVITED_CD] = "common_text_046"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_CONQUESTWAR_REINFORCEMENTS_INVITED] = "remains_btn_15"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ALLIANCE_NOT_KING_ALLIANCE] = "conquestwar_text_42"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_RADIANCE_WAR_IN_GATE_OCCUPY_CD] = "common_text_4793"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_DEFENCE_NO_FIND_RUIN_WALL] = "Celestial_defense_text_018"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_DEFENCE_SERVER_TOWER_IN_WORKING] = "Celestial_defense_text_067"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_DEFENCE_SERVER_TOWER_USER_QUEUE_LIMIT] = "Celestial_defense_text_077"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MERGE_SERVER_TARGET_GROUP] = "CombineServers_51"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MERGE_SERVER_INVITE_KINGDOM] = "CombineServers_51"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MERGE_SERVER_AGREED_INVITE] = "CombineServers_51"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MERGE_SERVER_TARGET_AGREED_INVITE] = "CombineServers_54"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_STARS_WISHING_OTHER_ACTIVITY_NOT_OPEN] = "nebula_stars_wishing_text37"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_STARS_WISHING_OTHER_CASTLE_LV_NOT_ENOUGH] = "nebula_stars_wishing_text37"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DIVINE_BEAST_MARK_BEAST_STATE_ERROR] = "Divine_beast_mark_text_8"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_DIVINE_BEAST_MARK_BAG_FULL] = "Divine_beast_mark_text_11"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_NEBULA_ALL_STAR_CANNOT_SPEED] = "NebulaAllstar_397"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ROARING_FLAME_WAR_USE_SPEED_LIMIT] = "flames_dunes_text282"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MASS_SETTING_WHITELIST_REACH_LIMIT] = "common_text_4913"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_SLAVE_ARMY_CLASS_LIMIT] = "common_text_4902"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_SLAVE_ARMY_LEVEL_LIMIT] = "common_text_4902"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_MASS_SLAVE_ARMY_NUM_LIMIT] = "common_text_4902"
;(function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_MAP_QUEUE_SPEED_CD] = "common_text_4957"
local (function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end)[gErrDef.Err_ROARING_FLAME_WAR_NOT_IN_WAR_MAP], codeConfig = "flames_dunes_text358", function(notice_id, data, iconType, iconID)
	if notice_id then
		local fun = msgNotice.getSpecialFun(notice_id)
		if nil == fun then
			msgNotice = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			;(nil).messageID = notice_id
			msgNotice, (nil).param = nil, data
			;(nil).iconType = iconType
			;(nil).iconData, (nil).iconID = nil, iconID
			SoraDSendMessage(nil)
		elseif "function" == type(fun) then
			local msgNotice, rsp = type(fun), type(fun)
			rsp.data = data
			fun(notice_id, rsp, iconType, iconID)
		end
	else
	end
end
function msgNotice.getTipCode(err)
	return codeConfig[err]
end
local _ENV, specialFun = "getTipCode", "getTipCode"
function specialFun.example(notice_id, rsp)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
	;(nil).param, _ENV, (nil).messageID = nil, nil, notice_id
	SoraDSendMessage(nil)
end
function specialFun.notice_0121(notice_id, rsp)
	local itemID = rsp.data.itemID
	local count = rsp.data.count
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
	_ENV, (nil).messageID = nil, notice_id
	;(nil).param, (nil).itemID = nil, itemID
	SoraDSendMessage(nil)
end
function specialFun.notice_0122(notice_id, rsp)
	local itemID = rsp.data.itemID
	local level = backpackltCtrl:getCastleLevelCond(itemID)
	backpackltCtrl = itemID
	itemID.msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
	backpackltCtrl, itemID.messageID = nil, notice_id
	;(nil).level = level
	itemID.param, (nil).itemID = nil, itemID
	SoraDSendMessage(itemID)
end
function specialFun.notice_0123(notice_id, rsp)
	local itemID = rsp.data.itemID
	local level = backpackltCtrl:getLordLevelCond(itemID)
	backpackltCtrl = itemID
	itemID.msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
	backpackltCtrl, itemID.messageID = nil, notice_id
	;(nil).level = level
	itemID.param, (nil).itemID = nil, itemID
	SoraDSendMessage(itemID)
end
function specialFun.notice_0106(notice_id, rsp)
	local data = rsp.data
	if data then
		local itemID = data.itemID
		if gItemEffectDef.GIVE_ITEM == backpackltCtrl:getResultType(itemID) then
			_ENV = backpackltCtrl:getResultType(itemID)
			backpackltCtrl:getResultType(itemID).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			_ENV, backpackltCtrl:getResultType(itemID).messageID = backpackltCtrl, notice_id
			backpackltCtrl:getResultType(itemID).param, backpackltCtrl.itemID = backpackltCtrl, itemID
			SoraDSendMessage((backpackltCtrl:getResultType(itemID)))
		end
	end
end
function specialFun.notice_0117(notice_id, rsp, iconType, iconID)
	local data = rsp.data
	if data then
		local itemID = data.itemID
		local count = data.count
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
		_ENV, (nil).messageID = nil, notice_id
		;(nil).itemID = itemID
		_ENV, (nil).param, (nil).count = nil, nil, count
		;(nil).iconType = iconType
		;(nil).iconData, (nil).iconID = nil, iconID
		SoraDSendMessage(nil)
	end
end
function specialFun.notice_0116(notice_id, rsp, iconType, iconID)
	local data = rsp.data
	if data then
		local itemID = data.itemID
		local count = data.count
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
		_ENV, (nil).messageID = nil, notice_id
		;(nil).itemID = itemID
		_ENV, (nil).param, (nil).count = nil, nil, count
		;(nil).iconType = iconType
		;(nil).iconData, (nil).iconID = nil, iconID
		SoraDSendMessage(nil)
	end
end
function specialFun.common_text_1947(notice_id, rsp)
	local gametop = gModuleMgr.getObject("gametop")
	local badgeExchangeCtrl = gametop.playertop_:getModule("badgeExchangeCtrl")
	local limit = badgeExchangeCtrl:getMostLimit()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
	_ENV, (nil).messageID = nil, notice_id
	;(nil).param, (nil).max = nil, limit
	SoraDSendMessage(nil)
end
function specialFun.common_text_2565(notice_id, rsp)
	local data = rsp.data
	if data and data.errParms then
		local resId = data.errParms.resId
		print("resId=", resId)
		_ENV = "resId="
		;("resId=").msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
		_ENV, ("resId=").messageID = resId, notice_id
		;("resId=").param, resId.resourceID = resId, resId
		SoraDSendMessage("resId=")
	end
end
function specialFun.brightWar_text_203(notice_id, rsp)
	local data = rsp.data
	if data and data.errParms then
		local objId = data.errParms.mapObjId
		print("objId=", objId)
		local kingdomMapUtil = include("kingdomMapUtil")
		local _ENV, mapObj = "kingdomMapUtil", "kingdomMapUtil"
		mapObj.x, mapObj.y, mapObj.type, mapObj.subMapType, mapObj.objId = kingdomMapUtil.gSplitId(objId)
		local mapObjUtil = include("mapObjUtil")
		local name = mapObjUtil.getBuildName(mapObj.type, mapObj.subMapType, mapObj.objId)
		_ENV = nil
		;(nil).name = name
		SoraDShowMsgTip(i18n("brightWar_text_203", nil))
	end
end
function specialFun.common_text_3111(notice_id)
	SoraDShowMsgBox(i18n("common_text_3111"), i18n("common_text_054"), nil, nil)
end
function specialFun.tips_acs_invitationCD(notice_id)
	local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
	local constValue = kohMigrateCtrl:getAcrossParam("across_invitationCD")
	_ENV = "across_invitationCD"
	;("across_invitationCD").msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
	_ENV, ("across_invitationCD").messageID = nil, notice_id
	;("across_invitationCD").param, (nil).var1 = nil, math.ceil(constValue / 60)
	SoraDSendMessage("across_invitationCD")
end
function specialFun.brightWar_text_129(notice_id, rsp)
	local data = rsp and rsp.data
	if not data then
		return
	end
	local queueToId = data.queueToId
	local objId = data.objId
	if queueToId or objId then
		local kingdomMapUtil = include("kingdomMapUtil")
		local radianceWarDef = include("radianceWarDef")
		if queueToId then
			_ENV = "radianceWarDef"
			local ("radianceWarDef").id, mapObj = queueToId, "radianceWarDef"
			kingdomMapUtil.splitMapObjId(mapObj)
			objId = mapObj.objId
		end
		if objId == radianceWarDef.RADIANCE_WAR_PALACE_ID or radianceWarDef.RADIANCE_WAR_PALACE_BEACON_ID[objId] then
			notice_id = "brightWar_text_237"
		end
		_ENV = kingdomMapUtil.splitMapObjId
		kingdomMapUtil.splitMapObjId.msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
		kingdomMapUtil.splitMapObjId.messageID = notice_id
		SoraDSendMessage(kingdomMapUtil.splitMapObjId)
	end
end
function specialFun.common_text_4793(notice_id, rsp)
	local data = rsp and rsp.data
	if data and data.errParms then
		local cd = data.errParms.cd
		if cd then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			_ENV, (nil).messageID = nil, notice_id
			;(nil).param, (nil).num = nil, cd
			SoraDSendMessage(nil)
		end
	end
end
function specialFun.common_text_4959(notice_id, rsp)
	local starLv = CONST_VALUE.CROSS_KINGDOM_WAR_MIGRATION_STAR_LV
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
	_ENV, (nil).messageID = nil, notice_id
	;(nil).param, (nil).lv = nil, starLv
	SoraDSendMessage(nil)
end
function msgNotice.getSpecialFun(notice_id)
	return specialFun[notice_id]
end
return msgNotice
