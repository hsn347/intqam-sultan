local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWar_FightBuildPanel = class("RoaringFlameWar_FightBuildPanel", baseFguiPanel)
function RoaringFlameWar_FightBuildPanel:ctor(...)
	self.isLRU = true
	RoaringFlameWar_FightBuildPanel.super.ctor(self, ...)
	print("RoaringFlameWar_FightBuildPanel:ctor", self.viewName)
end
function RoaringFlameWar_FightBuildPanel:onInit()
	print("=======RoaringFlameWar_FightBuildPanel:onInit")
	self.fields.Label_title:setString(i18n("mail_2_text_51"))
	self.fields.Text_noData:setString(i18n("flames_dunes_text233"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RoaringFlameWar_FightBuildPanel:endShow()
	print("=======RoaringFlameWar_FightBuildPanel:endShow")
	local ownerMap = roaringFlameWarUtil.getAllSelfCampWarBuildingOwner()
	local limit = roaringFlameWarUtil.getOccupyLimit()
	local ownerCount = table.nums(ownerMap)
	local remain = math.max(0, limit - ownerCount)
	_ENV = nil
	;(nil).val = remain
	;(nil).max = limit
	self.fields.Text_des:setString(i18n("flames_dunes_text163", nil))
	local queuesData = roaringFlameWarUtil.getQueuesData()
	self.dataList = queuesData
	dump(self.dataList, "==self.dataList==")
	_ENV = i18n("flames_dunes_text163", nil)
	i18n("flames_dunes_text163", nil).val = #self.dataList
	self.fields.Panel_bg:setString(i18n("flames_dunes_text164", i18n("flames_dunes_text163", nil)))
	self.fields.List:setNumItems(#self.dataList)
	self.fields.Text_noData:setVisible(0 >= #self.dataList)
end
function RoaringFlameWar_FightBuildPanel:onItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
		_fields.Text_pos:addClickListener(handler(self, self.onClickBtnPos))
	end
	local data = self.dataList[index + 1]
	local objId = data.objId
	local subMapType = data.subMapType
	local buildImage = roaringFlameWarRead.getBuildBattleIcon(subMapType)
	_fields.Load_build:setURL(buildImage)
	local buildLv = roaringFlameWarRead.getBuildLevel(objId)
	local buildName = roaringFlameWarRead.getBuildName(subMapType)
	_ENV = handler(self, self.onClickBtnPos)
	handler(self, self.onClickBtnPos).lv = buildLv
	handler(self, self.onClickBtnPos).name = buildName
	_fields.Text_name:setString(i18n("common_text_134", handler(self, self.onClickBtnPos)))
	local pos = roaringFlameWarRead.getBuildCoord(objId)
	_ENV = i18n("common_text_134", handler(self, self.onClickBtnPos))
	i18n("common_text_134", handler(self, self.onClickBtnPos)).x = pos.x
	i18n("common_text_134", handler(self, self.onClickBtnPos)).y = pos.y
	local posStr = i18n("common_text_2155", i18n("common_text_134", handler(self, self.onClickBtnPos)))
	_fields.Text_pos:setString(posStr)
	_fields.Text_pos.pos = pos
	if data.newClassType == gAllianceQueueClassType.pvp_def then
		obj:getController("c1"):setSelectedIndex(1)
	else
		obj:getController("c1"):setSelectedIndex(0)
	end
end
function RoaringFlameWar_FightBuildPanel:onClickBtnPos(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	SoraDGotoWorldMapPoint(button.pos, true)
	self:closePanel()
end
return RoaringFlameWar_FightBuildPanel
