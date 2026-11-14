local allianceDesRead = include("allianceDesRead")
local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamChangeFlagPanel = class("NebulaWarTeamChangeFlagPanel", baseFguiPanel)
function NebulaWarTeamChangeFlagPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamChangeFlagPanel:ctor", self.viewName)
end
function NebulaWarTeamChangeFlagPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarTeamChangeFlagPanel:onInit()
	print("=======NebulaWarTeamChangeFlagPanel:onInit")
	self.fields.List_flag:setItemRenderer(handler(self, self.onFlagItemRederer))
	self.fields.List_flag:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Button_change:setString(i18n("common_text_243"))
	self.fields.Button_change:addClickListener(handler(self, self.onClickBtnChange))
	self.fields.Button_cancel:setString(i18n("common_text_184"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickClose))
end
function NebulaWarTeamChangeFlagPanel:onShow()
	print("=======NebulaWarTeamChangeFlagPanel:onShow")
	self.areaEnum = self.proxy.param and self.proxy.param.areaEnum or teamAreaEnum.NEBULA_WAR
	if self.areaEnum == teamAreaEnum.NEBULA_WAR then
		self:setNebulaView()
	end
end
function NebulaWarTeamChangeFlagPanel:setNebulaView(...)
	_UPVALUE15_ = nil
	self.tableFlagList, (nil)[1] = nil, 1
	self.tableFlagList, (nil)[2] = nil, 2
	self.tableFlagList, (nil)[3] = nil, 3
	self.tableFlagList, (nil)[4] = nil, 4
	self.tableFlagList, (nil)[5] = nil, 5
	self.tableFlagList, (nil)[6] = nil, 6
	self.tableFlagList, (nil)[7] = nil, 7
	self.tableFlagList, (nil)[8] = nil, 8
	self.tableFlagList, (nil)[9] = nil, 9
	self.tableFlagList, (nil)[10] = nil, 10
	self.tableFlagList, (nil)[11] = nil, 11
	self.tableFlagList, (nil)[12] = nil, 12
	self.tableFlagList, (nil)[13] = nil, 13
	self.tableFlagList, (nil)[14] = nil, 14
	self.tableFlagList, (nil)[15] = nil, 15
	self.fields.List_flag:setNumItems(#self.tableFlagList)
	self:refreshTeamFlag()
	self:updateFlag(self.teamFlag)
	self.fields.List_flag:scrollToView(self.curFlag - 1)
	self.fields.List_flag:getChildAt(self.curFlag - 1):setSelected(true)
end
function NebulaWarTeamChangeFlagPanel:refreshTeamFlag(...)
	if self.areaEnum == teamAreaEnum.NEBULA_WAR then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
		self.teamFlag = myTeamInfo:getTeamFlag()
	end
end
function NebulaWarTeamChangeFlagPanel:refreshBtnChange(...)
	self.fields.Button_change:setEnabled(self.teamFlag ~= self.curFlag)
end
function NebulaWarTeamChangeFlagPanel:onFlagItemRederer(index, obj)
	local flagIndex = self.tableFlagList[index + 1]
	if obj.flagIndex == flagIndex then
		return
	end
	obj.flagIndex = flagIndex
	local Loader3D = obj:getChild("Loader3D")
	Loader3D:clearContent()
	local __, nodeFlag = allianceDesRead.getFlagWithParticle(flagIndex)
	Loader3D:setContent(nodeFlag)
end
function NebulaWarTeamChangeFlagPanel:onClickItem(EventContext)
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_flag:getChildIndex(obj)
	local flagIndex = childIndex + 1
	self:updateFlag(flagIndex)
end
function NebulaWarTeamChangeFlagPanel:onClickBtnChange(...)
	SoraDPlaySound()
	if self.areaEnum == teamAreaEnum.NEBULA_WAR then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
		myTeamInfo:reqTeamSetFlag(self.curFlag)
		SoraDShowLoading(self:displayObject())
	end
end
function NebulaWarTeamChangeFlagPanel:updateFlag(flag)
	if self.curFlag == flag then
		return
	end
	self.curFlag = flag
	self.fields.Loader3D:clearContent()
	local __, nodeFlag = allianceDesRead.getFlagWithParticle(self.curFlag)
	self.fields.Loader3D:setContent(nodeFlag)
	self:refreshBtnChange()
end
return NebulaWarTeamChangeFlagPanel
