local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWar_BuildLogPanel = class("RoaringFlameWar_BuildLogPanel", baseFguiPanel)
function RoaringFlameWar_BuildLogPanel:ctor(...)
	self.isLRU = true
	RoaringFlameWar_BuildLogPanel.super.ctor(self, ...)
	print("RoaringFlameWar_BuildLogPanel:ctor", self.viewName)
end
function RoaringFlameWar_BuildLogPanel:onInit()
	print("=======RoaringFlameWar_BuildLogPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_836"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_noData:setString(i18n("flames_dunes_text313"))
end
function RoaringFlameWar_BuildLogPanel:endShow()
	print("=======RoaringFlameWar_BuildLogPanel:endShow")
	self.camp = roaringFlameWarCtrl:getSelfCamp()
	roaringFlameWarCtrl:reqCampOccupyLog()
end
function RoaringFlameWar_BuildLogPanel:onItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
		_fields.Text_log:addClickListener(handler(self, self.onClickBtnPos))
	end
	local data = self.logList[index + 1]
	_fields.Image_white:setVisible(index % 2 ~= 0)
	_ENV = _fields.Image_white
	_fields.Image_white.selfCamp = self.camp
	_fields.Image_white.data = data
	local logStr = roaringFlameWarUtil.parseBuildLog(_fields.Image_white)
	_fields.Text_log:setString(logStr)
	local objId = data.bId
	local pos = roaringFlameWarRead.getBuildCoord(objId)
	_fields.Text_log.pos = pos
	_fields.Text_time:setString(SoraDConverTimeStr(data.t))
end
function RoaringFlameWar_BuildLogPanel:onClickBtnPos(EventContext)
	SoraDPlaySound()
	if not worldMapDefine.isInRoaringFlame() then
		SoraDShowMsgTip(i18n("brightWar_text_79"))
		return
	end
	local button = EventContext:getSender()
	SoraDGotoWorldMapPoint(button.pos, true)
	SoraDRemoveAllPanelFromManager()
end
function RoaringFlameWar_BuildLogPanel:onMsgUpdateBuildLog(target, event)
	if not event.rspdata then
		_UPVALUE0_ = event.rspdata
	end
	self.logList = event.rspdata
	self.fields.List:setNumItems(#self.logList)
	self.fields.Text_noData:setVisible(#self.logList <= 0)
end
return RoaringFlameWar_BuildLogPanel
