local salesRoomAgCtrl = SoraDGetCtrl("salesRoomAgCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local tradeBoardMoneyViewPanel = class("tradeBoardMoneyViewPanel", baseFguiPanel)
function tradeBoardMoneyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("tradeBoardMoneyViewPanel:ctor", self.viewName)
end
function tradeBoardMoneyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function tradeBoardMoneyViewPanel:onInit()
	print("=======tradeBoardMoneyViewPanel:onInit")
	self.dataList, _ENV, self.tag = print, print, 1
	self.fields.Panel_bg:setString(i18n("common_text_3368"))
	self.fields.Text_none:setString(i18n("common_text_1464"))
	self.fields.Button_gainAll:setString(i18n("common_text_3369"))
	self.fields.Button_gainAll:addClickListener(handler(self, self.btnGainAllClick))
	self.fields.List_money:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_money:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEndItem))
	self.fields.List_record:setItemRenderer(handler(self, self.onRecordRenderer))
	self.fields.List_record:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEndItem))
end
function tradeBoardMoneyViewPanel:onShow()
	print("=======tradeBoardMoneyViewPanel:onShow")
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("common_text_3368")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("common_text_2813")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(nil)
end
function tradeBoardMoneyViewPanel:onItemRenderer(index, obj)
	obj:initData(self.dataList[index + 1])
end
function tradeBoardMoneyViewPanel:onRecordRenderer(index, obj)
	obj:initData(self.dataList[index + 1])
end
function tradeBoardMoneyViewPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		salesRoomAgCtrl:sendGoldLogMsg(1)
	else
		salesRoomAgCtrl:sendLogMsg(1)
	end
end
function tradeBoardMoneyViewPanel:refreshGold()
	self.rGold = salesRoomAgCtrl:getNotReceiveGold()
	if self.rGold and tonumber(self.rGold) > 0 then
		self.fields.Button_gainAll:setEnabled(true)
	else
		self.fields.Button_gainAll:setEnabled(false)
	end
end
function tradeBoardMoneyViewPanel:onScrollEndItem()
	print("self.wGet,self.sIndex=====", self.wGet, self.sIndex)
	if self.wGet and self.sIndex then
		if self.tag == 1 then
			salesRoomAgCtrl:sendGoldLogMsg(self.sIndex)
		else
			salesRoomAgCtrl:sendLogMsg(self.sIndex)
		end
	end
end
function tradeBoardMoneyViewPanel:initData(target, data)
	self.sIndex = data.idx
	if not data.datalog then
		_ENV = data.datalog
	end
	self.rData = data.datalog
	self.wGet = data.wget
	if self.tag == 1 then
		local _ENV, data = self.tag, self.tag
		for k, v in ipairs(self.rData) do
			if v.show then
				table.insert(data, v)
			end
		end
		self.dataList = data
		self:refreshGold()
		self.fields.List_money:setNumItems(#self.dataList)
	else
		self.dataList = self.rData
		self.fields.List_record:setNumItems(#self.dataList)
	end
	self:onScrollEndItem()
	self.fields.Text_none:setVisible(#self.dataList == 0)
end
function tradeBoardMoneyViewPanel:btnGainAllClick()
	SoraDPlaySound()
	if self.rGold and tonumber(self.rGold) > 0 then
		salesRoomAgCtrl:sendReceiveGold()
	end
end
return tradeBoardMoneyViewPanel
