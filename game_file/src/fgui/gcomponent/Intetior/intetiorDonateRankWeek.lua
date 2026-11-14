local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local baseComponent = require("fgui.base.baseComponent")
local intetiorDonateRankWeek = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/intetiorDonateRankWeek", intetiorDonateRankWeek)
local MAX_REQ_NUM = 10
function intetiorDonateRankWeek:onInit()
	self.myRankData, _ENV, self.rankData, _ENV, self.sIndex = nil, nil, nil, nil, 1
	self.fields.Text_des:setString(i18n("parliament_title_03"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.scrollEventCallBack))
	self.fields.text_tips:setString(i18n("parliament_text_16"))
end
function intetiorDonateRankWeek:onShow()
	self:setSelfInfo()
	self:reqSendMsg(self.sIndex)
end
function intetiorDonateRankWeek:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TREASURY_DONATE_RANK", handler(self, self.initData))
end
function intetiorDonateRankWeek:reqSendMsg(index)
	SoraDShowLoading(self)
	intetiorCtrl:reqParliamentTreasuryDonateRank(index, MAX_REQ_NUM)
end
function intetiorDonateRankWeek:setSelfInfo()
	self.fields.node_self:initData(self.myRankData)
end
function intetiorDonateRankWeek:initData(target, data)
	SoraDCloseLoading(self)
	if data.myInfo and next(data.myInfo) then
		self.myRankData = data.myInfo
		self:setSelfInfo()
	end
	self:initScrollData(data)
end
function intetiorDonateRankWeek:initScrollData(data)
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
function intetiorDonateRankWeek:initScrollView()
	if #self.rankData <= 0 then
		self.fields.text_tips:setVisible(true)
		self.fields.List:setVisible(false)
	else
		self.fields.text_tips:setVisible(false)
		self.fields.List:setVisible(true)
		self.fields.List:setNumItems(#self.rankData)
	end
end
function intetiorDonateRankWeek:onItemRederer(index, target)
	target:initData(self.rankData[index + 1])
end
function intetiorDonateRankWeek:scrollEventCallBack()
	if self.wGet then
		self:reqSendMsg(self.sIndex)
	end
end
return intetiorDonateRankWeek
