local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameTreasureCave_DetailPanel = class("RoaringFlameTreasureCave_DetailPanel", baseFguiPanel)
function RoaringFlameTreasureCave_DetailPanel:ctor(...)
	self.isLRU = true
	RoaringFlameTreasureCave_DetailPanel.super.ctor(self, ...)
	print("RoaringFlameTreasureCave_DetailPanel:ctor", self.viewName)
end
function RoaringFlameTreasureCave_DetailPanel:onInit()
	print("=======RoaringFlameTreasureCave_DetailPanel:onInit")
	self.caveWeekTimes = roaringFlameWarRead.getConstValue("FLAMES_DUNES_CAVE_WEEK_TIMES", 5)
	self.topRewardCfg = roaringFlameWarRead.getCaveRewardCfg(2)
	self.fields.Panel_bg:setString(i18n("flames_dunes_text139"))
	_ENV = i18n("flames_dunes_text139")
	i18n("flames_dunes_text139").num = #self.topRewardCfg
	self.fields.Text_tip:setString(i18n("flames_dunes_text151", i18n("flames_dunes_text139")))
	self.fields.Text_none:setString(i18n("god_beast_text_16"))
	self.fields.Text_none:setVisible(false)
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setItemRenderer(handler(self, self.onRecordRenderer))
	self.view:fixChildrenPos()
end
function RoaringFlameTreasureCave_DetailPanel:onItemRenderer(index, obj)
	obj:initData(self.cfgList[index + 1].id, self.cfgList[index + 1].count)
end
function RoaringFlameTreasureCave_DetailPanel:onRecordRenderer(index, obj)
	obj:initData(self.recordList[index + 1])
end
function RoaringFlameTreasureCave_DetailPanel:endShow()
	print("=======RoaringFlameTreasureCave_DetailPanel:endShow")
	self.data = self.param.data
	if not self.param.playerInfo then
		_ENV = self.param.playerInfo
	end
	self.playerInfo = self.param.playerInfo
	if not self.param.receiveRecord then
		_ENV = self.param.receiveRecord
	end
	self.cfgList, _ENV, self.recordList = self.param.receiveRecord, self.param.receiveRecord, self.param.receiveRecord
	if SoraDFIsRA() then
		for k, v in ipairs(self.topRewardCfg) do
			_ENV = nil
			;(nil).id = v.rewards[1].id
			;(nil).count = v.rewards[1].count
			table.insert(self.cfgList, 1, nil)
		end
	else
		for k, v in ipairs(self.topRewardCfg) do
			_ENV = 1
			;(1).id = v.rewards[1].id
			;(1).count = v.rewards[1].count
			table.insert(self.cfgList, 1)
		end
	end
	self.fields.List_award:setNumItems(#self.cfgList)
	self.fields.Com_head:setHeadSprite(self.playerInfo.imageId, self.playerInfo.avatar)
	self.fields.Com_head:setPlayerID(self.playerInfo.uid)
	self.fields.Com_head:setKid(self.playerInfo.kid)
	self.fields.Text_name:setString(self.data.userName)
	local campName = roaringFlameWarRead.getCampName(self.data.campId)
	local campColor = roaringFlameWarRead.getCampColor(self.data.campId)
	_ENV = self.cfgList
	self.cfgList.camp = fguiHelper.getColorString(SoraDRGB2HtmlColor(campColor), campName)
	self.cfgList.kid = self.playerInfo.kid
	self.fields.Text_camp:setString(i18n("%{camp}#%{kid}", self.cfgList))
	self:initRecordList()
	roaringFlameWarCtrl:reqCaveData()
	SoraDShowLoading(self)
end
function RoaringFlameTreasureCave_DetailPanel:initRecordList()
	local prizer
	self.fields.List:setNumItems(#self.recordList)
	self.fields.Text_none:setVisible(#self.recordList == 0)
	for k, v in ipairs(self.recordList) do
		if v.prize then
			prizer = v.userName
			break
		end
	end
	if prizer then
		_ENV = nil
		;(nil).name = fguiHelper.getColorString("#F0E6D2", prizer)
		self.fields.Label_title:setString(i18n("flames_dunes_text152", nil))
	else
		self.fields.Label_title:setString("")
	end
end
function RoaringFlameTreasureCave_DetailPanel:initView(target, data)
	SoraDCloseLoading(self)
	if data and data.key == "data" then
		local count = self.caveWeekTimes - (data.receiveCaveCount or 0)
		_ENV = nil
		;(nil).num = fguiHelper.getColorString(0 < count and "#F0E6D2" or "#E02B2B", count)
		;(nil).max = self.caveWeekTimes
		self.fields.Text_count:setString(i18n("flames_dunes_text153", nil))
	end
end
return RoaringFlameTreasureCave_DetailPanel
