local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local baseComponent = require("fgui.base.baseComponent")
local intetiorRecordTax = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/intetiorRecordTax", intetiorRecordTax)
local MAX_REQ_NUM = 10
function intetiorRecordTax:onInit()
	self.rankData, MAX_REQ_NUM = nil, nil
	self.sIndex = 1
	self.wGet = false
	self.pageSize = MAX_REQ_NUM
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.scrollEventCallBack))
	self.fields.text_tips:setString(i18n("common_text_927"))
end
function intetiorRecordTax:onShow()
	self:reqSendMsg(self.sIndex)
end
function intetiorRecordTax:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TREASURY_TAX_RECORD", handler(self, self.initData))
end
function intetiorRecordTax:reqSendMsg(index)
	SoraDShowLoading()
	intetiorCtrl:reqParliamentTreasuryTaxRecord(index, MAX_REQ_NUM)
end
function intetiorRecordTax:initData(target, data)
	SoraDCloseLoading()
	self:initScrollData(data)
end
function intetiorRecordTax:initScrollData(data)
	dump(data, "data", 10)
	if not data.rankList then
		local _ENV, rankList = data.rankList, data.rankList
	end
	local num = #rankList
	self.sIndex = self.sIndex + #rankList
	if data.wGet ~= nil then
		self.wGet = data.wGet
	else
		self.wGet = num >= MAX_REQ_NUM
	end
	if next(rankList) ~= nil then
		local cpyTbl = clone(rankList)
		for _, v in ipairs(cpyTbl) do
			table.insert(self.rankData, v)
		end
	end
	self:initScrollView()
end
function intetiorRecordTax:initScrollView()
	if #self.rankData <= 0 then
		self.fields.text_tips:setVisible(true)
		self.fields.List:setVisible(false)
	else
		self.fields.text_tips:setVisible(false)
		self.fields.List:setVisible(true)
		self.fields.List:setNumItems(#self.rankData)
	end
end
function intetiorRecordTax:onItemRender(index, target)
	target:initData(self.rankData[index + 1], 0)
end
function intetiorRecordTax:scrollEventCallBack()
	if self.wGet then
		self:reqSendMsg(self.sIndex)
	end
end
return intetiorRecordTax
