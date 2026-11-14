local baseProxy = require("fgui.base.baseProxy")
local AllianceBuildViewProxy = class("AllianceBuildViewProxy", baseProxy)
function AllianceBuildViewProxy:onRegisterEvent()
	print("=======AllianceBuildViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GUIDE_UPDATE", handler(self, self.initMailBtn))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RES_MINE_PROFIT_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GET_RES_MINE_PROFIT_BACK", handler(self, self.initRes))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", handler(self, self.initData))
end
function AllianceBuildViewProxy:initMailBtn(...)
	self.view:initMailBtn(...)
end
function AllianceBuildViewProxy:initData(...)
	self.view:initData(...)
end
function AllianceBuildViewProxy:initRes(...)
	self.view:initRes(...)
end
function AllianceBuildViewProxy:setBuildPos(pos)
	if not self.tableParam then
		_UPVALUE0_ = self.tableParam
	end
	self.tableParam = self.tableParam
	self.tableParam.buildMovePos = pos
end
function AllianceBuildViewProxy:getParam(...)
	if not self.tableParam then
		self.tableParam.buildMovePos, _UPVALUE0_, _UPVALUE0_ = nil, nil, self.tableParam
	end
	return self.tableParam
end
return AllianceBuildViewProxy
