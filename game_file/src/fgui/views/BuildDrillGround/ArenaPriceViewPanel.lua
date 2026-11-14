local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local arenaltCtrl = include("arenaltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaPriceViewPanel = class("ArenaPriceViewPanel", baseFguiPanel)
function ArenaPriceViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaPriceViewPanel:ctor", self.viewName)
end
function ArenaPriceViewPanel:onInit()
	print("=======ArenaPriceViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_2194"))
	self.fields.Text_des = SoraDCreateTimerLabel(self, self.fields.Text_des)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_noRecord:setString(i18n("arena_text_16"))
	self.fields.Text_noRecord:setVisible(false)
	self.fields.Button_gain:setString(i18n("common_text_1146"))
	self.fields.Button_gain:addClickListener(handler(self, self.btnGainClick))
	self.fields.Button_gain:setEnabled(false)
	_ENV = handler(self, self.btnGainClick)
	handler(self, self.btnGainClick).num = 20
	self.fields.Text_tip:setString(i18n("arena_text_17", handler(self, self.btnGainClick)))
end
function ArenaPriceViewPanel:onShow()
	print("=======ArenaPriceViewPanel:onShow")
	self:req4info(self.param.bType, self.param.blockID)
end
function ArenaPriceViewPanel:gainCallBack(target, redata)
	SoraDCloseLoading(self:displayObject())
	if redata and redata.gainItems then
		SoraDShowMsgTip(i18n("arena_text_14"))
		SoraDMailGainItems(redata.gainItems, true)
	end
	self:req4info(self.battleType, self.blockID)
end
function ArenaPriceViewPanel:req4info(bType, blockID)
	self.battleType = bType
	self.blockID = blockID
	self.myInfo = arenaCtrl:getBattleInfo(self.battleType)
	if not self.myInfo.rewards then
		arenaCtrl = self.myInfo.rewards
	end
	self.myRewardInfo = self.myInfo.rewards
	for i, v in ipairs(self.myRewardInfo) do
		if not v.time then
			v.time = serviceFunctions.systemTime()
		end
	end
	table.sort(self.myRewardInfo, function(l, r)
		return l.time > r.time
	end)
	if not self.rewardInfo then
		self.rewardInfo = arenaltCtrl.getRewardByType(self.battleType, self.blockID)
	end
	self:initData()
end
function ArenaPriceViewPanel:initData()
	arenaCtrl:clickRewardTip(self.battleType)
	self:initView()
end
function ArenaPriceViewPanel:refreshTime()
	local timeOut = arenaCtrl:getRewardTime(self.battleType)
	self.fields.Text_des:setTimeLast(function(str)
		_ENV = nil
		;(nil).time = str
		return i18n("arena_text_13", nil)
	end)
	self.fields.Text_des:beginTime(timeOut)
end
function ArenaPriceViewPanel:initView()
	self:refreshTime()
	local hasRecord = #self.myRewardInfo > 0
	self.fields.Button_gain:setEnabled(hasRecord)
	self.fields.Text_noRecord:setVisible(not hasRecord)
	self.fields.List:setNumItems(#self.myRewardInfo)
end
function ArenaPriceViewPanel:onItemRenderer(index, obj)
	local data = self.myRewardInfo[index + 1]
	local _fields = obj._fields
	if not _fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
		if not SoraDFIsRA() then
			_fields.Text_title:fixPos()
			_fields.Text_time:fixPos()
		end
	end
	if data and data.rank then
		_ENV = nil
		;(nil).num = data.rank
		_fields.Text_title:setString(i18n("common_text_617", nil))
	end
	if data and data.time then
		_fields.Text_time:setString(SoraDConvertTimeToDate(data.time, false, true))
	end
	local cfg = self:findRankInfo(data.rank)
	if cfg and cfg.award then
		local itemList = SoraDIntArr2FormatTable(cfg.award)
		_fields.List:setItemRenderer(function(_index, _obj)
			local _data = itemList[_index + 1]
			_obj:initData(_data.id, _data.num)
		end)
		_fields.List:setNumItems(#itemList)
	end
end
function ArenaPriceViewPanel:findRankInfo(_rank)
	for k, v in pairs(self.rewardInfo) do
		if _rank >= v.ranking[1] and _rank <= v.ranking[2] then
			return v
		end
	end
end
function ArenaPriceViewPanel:btnGainClick()
	SoraDShowLoading(self:displayObject())
	arenaCtrl:req2gainReward(self.battleType)
end
return ArenaPriceViewPanel
