local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_TreasureCave_player = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameActivity/Com_TreasureCave_player", Com_TreasureCave_player)
function Com_TreasureCave_player:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self.fields.Label_time:setTimeEndListener(handler(self, self.updateCave))
end
function Com_TreasureCave_player:onShow()
end
function Com_TreasureCave_player:updateCave()
	roaringFlameWarCtrl:reqCampCaveList()
end
function Com_TreasureCave_player:initData(data, isMine)
	self.data = data
	if not isMine then
		_ENV = nil
		;(nil).name = self.data.userName
		self.fields.Text_name:setString(i18n("flames_dunes_text143", nil))
	else
		self.fields.Text_name:setString(i18n("flames_dunes_text131"))
	end
	local leftTime = self.data.endTime - serviceFunctions.systemTime() + 1
	if self.data.state == 1 then
		self.fields.Text_num:setVisible(false)
	else
		self.fields.Text_num:setVisible(true)
		local extraCfg = roaringFlameWarRead.getCaveRewardCfg(2)
		_ENV = i18n("flames_dunes_text131")
		if not self.data.receiveRecord then
			_ENV = self.data.receiveRecord
		end
		i18n("flames_dunes_text131").var1 = #self.data.receiveRecord
		i18n("flames_dunes_text131").var2 = #extraCfg
		self.fields.Text_num:setString(i18n("(%{var1}/%{var2})", i18n("flames_dunes_text131")))
	end
	self.fields.Label_time:beginTime(leftTime)
	self.fields.Label_time:setVisible(self.data.state == 1)
end
function Com_TreasureCave_player:btnClick()
	SoraDPlaySound()
	if not worldMapDefine.isInRoaringFlame() then
		SoraDShowMsgTip(i18n("brightWar_text_79"))
		return
	end
	local point = include("mapSyncUtilClient").serverTOClientPos(cc.p(self.data.x, self.data.y))
	SoraDGotoWorldMapPoint(point, true)
	SoraDRemoveAllPanelFromManager()
end
return Com_TreasureCave_player
