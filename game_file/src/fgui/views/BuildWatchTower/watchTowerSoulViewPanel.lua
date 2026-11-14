local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local romeActivityCtrl = SoraDGetCtrl("romeActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local watchTowerSoulViewPanel = class("watchTowerSoulViewPanel", baseFguiPanel)
function watchTowerSoulViewPanel:ctor(...)
	watchTowerSoulViewPanel.super.ctor(self, ...)
	print("watchTowerSoulViewPanel:ctor", self.viewName)
end
function watchTowerSoulViewPanel:onInit()
	print("=======watchTowerSoulViewPanel:onInit")
	self.tableSingle, _ENV, self.watchList, _ENV = print, print, print, print
	self.fields.Com_title:initData(i18n("common_text_1221"), handler(self, self.onClickClose))
	self.fields.Text_noArmy:setString(i18n("common_text_592"))
	self.fields.Text_noArmy:setVisible(false)
	self.fields.Text_romanTip:setString(i18n("common_text_1258"))
	self.fields.Lab_info:setString(i18n("common_text_3392"))
	self.fields.Button_ignoreAll:setString(i18n("common_text_1266"))
	self.fields.Button_ignoreAll:addClickListener(handler(self, self.btnIgnoreAllClick))
	self.fields.Button_romanHelp:setString(i18n("common_text_1259"))
	self.fields.Button_romanHelp:addClickListener(handler(self, self.btnRomanHelpClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_romanHelp:fixPos()
	self.fields.Text_romanTip:fixPos()
end
function watchTowerSoulViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableSingle[index + 1].data)
end
function watchTowerSoulViewPanel:onShow()
	print("=======watchTowerSoulViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_top:setGradientColor()
	self:refreshRomanNode()
	self:initData()
end
function watchTowerSoulViewPanel:initData()
	self.watchList = kingdomMapCtrl:getWatchTowerQueue():getRomanWatchTowerQueue()
	dump(self.watchList, "WatchTowerSoulView:initData", 10)
	self:refreshData()
end
function watchTowerSoulViewPanel:refreshData()
	self.fields.Text_noArmy:setVisible(not next(self.watchList))
	self:checkIgnore()
	self:prepareScrollData()
end
function watchTowerSoulViewPanel:prepareScrollData()
	self.tableSingle, _ENV = nil, nil
	local index = 1
	dump(self.watchList, "self.watchList===")
	for _, v in pairs(self.watchList) do
		_ENV = nil
		self.tableSingle[index], (nil).data = nil, v:getFilterDataByWatchTower()
		index = index + 1
	end
	self.fields.List:setNumItems(#self.tableSingle)
end
function watchTowerSoulViewPanel:refreshRomanNode(target, data)
	if gAllianceRomeActivityState.RUNNING == romeActivityCtrl.state then
		local romanTimeQueue = romeActivityCtrl:queryQueue("ROME_ACTIVITY_ATTACK_KEY")
		local leftTime = romanTimeQueue and romanTimeQueue.timerNode.timer:getRemainTime() or 0
		_ENV = nil
		;(nil).num = romeActivityCtrl.times
		self.fields.Text_romanBout:setString(i18n("common_text_1236", nil))
		self.fields.Text_romanTime:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("common_text_1239", nil)
		end)
		if 0 < leftTime then
			self.fields.Text_romanTime:beginTime(leftTime)
		end
	else
		self.fields.Text_romanBout:setString("")
		self.fields.Text_romanTime:endTime()
		self.fields.Text_romanTime:setString(i18n("mail_text_118"))
	end
end
function watchTowerSoulViewPanel:reciveData(target, redata)
	if "MESSAGE_SERVER_WATCHSOULTOWER_ADDINFO" == redata.msg then
		self.watchList[redata.indexID] = redata.data
	elseif "MESSAGE_SERVER_WATCHSOULTOWER_REMOVEINFO" == redata.msg then
		self.watchList[redata.indexID] = nil
	elseif "MESSAGE_SERVER_WATCHSOULTOWER_EDITINFO" == redata.msg then
		self.watchList[redata.indexID] = redata.data
	end
	self:refreshData()
end
function watchTowerSoulViewPanel:checkIgnore(target, data)
	if kingdomMapCtrl:getWatchTowerQueue():isIgnoreRomanSoul() then
		self.fields.Button_ignoreAll:setEnabled(false)
	else
		self.fields.Button_ignoreAll:setEnabled(true)
	end
end
function watchTowerSoulViewPanel:btnRomanHelpClick()
	SoraDPlaySound()
	local panel = uiManager:show("AllianceWarView")
	panel.view:tabChange(gAllianceQueueClassType.pve)
end
function watchTowerSoulViewPanel:btnIgnoreAllClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("common_text_1504")
	;(nil).confirmString = i18n("common_text_204")
	;(nil).confirmFunc = function()
		kingdomMapCtrl:getWatchTowerQueue():ignoreRomanSoul()
		kingdomMapCtrl = kingdomMapCtrl:getWatchTowerQueue()
		kingdomMapCtrl:getWatchTowerQueue().msg = "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROL"
		SoraDSendMessage((kingdomMapCtrl:getWatchTowerQueue()))
	end
	uiManager:show("MessageBox", nil)
end
return watchTowerSoulViewPanel
