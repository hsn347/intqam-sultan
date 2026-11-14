local gametop = gModuleMgr.getObject("gametop")
local contactCtrl = gametop.playertop_:getModule("contactCtrl")
local CommonFriendListView = class("commonFriendListView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonFriendListView")
	end
	return target
end)
function CommonFriendListView:ctor()
	self.sendList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("CounterSystem_text_33"))
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_1464"))
	self.labelNotice:setVisible(false)
	self.nodeCopy = SoraDGetChildByName(self, "Node_copy")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
end
function CommonFriendListView:updateData()
	local friendData = contactCtrl:getContactList()
	local myKindomID = gametop.playertop_:getMapID()
	self.friendData, contactCtrl = gametop.playertop_, gametop.playertop_
	for uid, v in pairs(friendData) do
		if v.sourceKid == myKindomID then
			v.uid = tonumber(uid)
			table.insert(self.friendData, v)
		end
	end
	table.sort(self.friendData, function(l, r)
		return l.totalFc > r.totalFc
	end)
	self.scroll:updateScrollView(cc.size(640, 120), self.friendData, 1)
	self.labelNotice:setVisible(#self.friendData <= 0)
end
function CommonFriendListView:createSingle()
	local single = self.nodeCopy:clone()
	single.nodeHead = SoraDGetExtendChildFromCCSByName(single, "CCS_commonHead_head")
	single.labelName = SoraDGetChildByName(single, "Text_name")
	single.labelPower = SoraDGetChildByName(single, "Text_power")
	single.btnSend = SoraDGetChildByName(single, "Button_send")
	single.btnSend:addTouchEventListener(handler(self, self.btnClickCallBack))
	single.btnSend:setTitleText(self.sendStr)
	return single
end
function CommonFriendListView:refreshSingle(single, data, otherData)
	single.nodeHead:setHeadSprite(data.iconID, data.avatar)
	if data.allianceAbbr and data.allianceAbbr ~= "" then
		_ENV = nil
		;(nil).abbr = data.allianceAbbr
		;(nil).name = data.name
		single.labelName:setString(i18n("common_text_186", nil))
	else
		single.labelName:setString(data.name)
	end
	_ENV = i18n("common_text_186", nil)
	i18n("common_text_186", nil).power = string.formatnumberthousands(data.totalFc)
	single.labelPower:setString(i18n("common_text_128", i18n("common_text_186", nil)))
	if self.sendList[data.uid] then
		single.btnSend:setTouchEnabled(false)
		single.btnSend:setBright(false)
	else
		single.btnSend:setTouchEnabled(true)
		single.btnSend:setBright(true)
		single.btnSend:setTag(data.uid)
	end
end
function CommonFriendListView:setHand(handl)
	self.handle = handl
end
function CommonFriendListView:selectBtn(str)
	self.sendStr = str
end
function CommonFriendListView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local uid = button:getTag()
		if self.handle then
			self.handle(uid)
		end
		self.sendList[uid] = true
		button:setTouchEnabled(false)
		button:setBright(false)
	end
end
return CommonFriendListView
