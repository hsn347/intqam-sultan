local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleHonourBoardProxy = class("kingdomBattleHonourBoardProxy", baseProxy)
function kingdomBattleHonourBoardProxy:onRegisterEvent()
	print("=======kingdomBattleHonourBoardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_HONOURDATA", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_KINGDOMBATTLE_HONOURBOARD_RESULT", handler(self, self.onMsgReqKidBattleResultRsp))
end
function kingdomBattleHonourBoardProxy:initData(...)
	self.view:initData(...)
end
function kingdomBattleHonourBoardProxy:sortByKing(tbl)
	_UPVALUE2_, _UPVALUE1_ = nil, nil
	;(nil)[1] = "kid"
	;(nil)[2] = "<"
	;(nil)[1] = nil
	serviceFunctions.sort(tbl, nil)
	return tbl
end
function kingdomBattleHonourBoardProxy:sortByScore(tbl)
	_UPVALUE2_, _UPVALUE2_ = nil, nil
	_UPVALUE2_, (nil)[1] = "score", "score"
	_UPVALUE2_, (nil)[2] = "score", ">"
	;("score")[1] = "kid"
	;("score")[2] = "<"
	;(nil)[1] = nil
	;(nil)[2] = "score"
	serviceFunctions.sort(tbl, nil)
	return tbl
end
function kingdomBattleHonourBoardProxy:sortByWin(tbl)
	_UPVALUE2_, _UPVALUE3_ = nil, nil
	_UPVALUE2_, (nil)[1] = "win", "win"
	_UPVALUE2_, (nil)[2] = "win", ">"
	_UPVALUE2_, ("win")[1] = "total", "total"
	_UPVALUE2_, ("win")[2] = "total", "<"
	;("total")[1] = "kid"
	;("total")[2] = "<"
	;(nil)[1] = nil
	;(nil)[2] = "win"
	;(nil)[3] = "total"
	serviceFunctions.sort(tbl, nil)
	return tbl
end
function kingdomBattleHonourBoardProxy:onMsgReqKidBattleResultRsp(target, event)
	SoraDCloseLoading(self.view:displayObject())
	if event.err == gErrDef.Err_None then
		if event.data and next(event.data) then
			_ENV = self.view:displayObject()
			self.view:displayObject().data = event.data
			uiManager:show("kingdomBattleHonourBoardPop", self.view:displayObject())
		else
			SoraDShowMsgTip(i18n("common_text_4657"))
		end
	end
end
return kingdomBattleHonourBoardProxy
