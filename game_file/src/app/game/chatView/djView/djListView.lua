local djCtrl = SoraDGetCtrl("djCtrl")
local DjListView = class("djListView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("djListView")
	end
	return target
end)
function DjListView:ctor()
	self.tableSingle, _ENV = nil, nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeTitle:setTitleName(i18n("Anchor_text_37"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_scroll")
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_ATTENTION_UPDATE", handler(self, self.updateAttention))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.updateView))
	self:updateView()
end
function DjListView:updateView()
	self.djList = djCtrl:getDJTimeList()
	self:hiddleAll()
	local scrollH = math.max(self.scroll:getContentSize().height, 125 * #self.djList)
	self.scroll:setInnerContainerSize(cc.size(480, scrollH))
	for i, v in ipairs(self.djList) do
		local single = self:createSingle(v, i)
		single:setPosition(240, scrollH - (i - 1) * 125)
	end
	SoraDCloseLoading(self)
end
function DjListView:updateAttention()
	for i, v in ipairs(self.tableSingle) do
		local isAttention = djCtrl:isAttentionDJ(v.uid)
		if v.isAttention ~= isAttention then
			v.isAttention = isAttention
			v.btnAttention:setTitleText(v.isAttention and i18n("Anchor_text_38") or i18n("Anchor_text_39"))
			v.btnAttention:loadTextures(v.isAttention and "btn_red_small_01.png" or "btn_green_small_01.png", "", "", ccui.TextureResType.plistType)
		end
	end
	SoraDCloseLoading(self)
end
function DjListView:hiddleAll()
	for i, v in ipairs(self.tableSingle) do
		v:setVisible(false)
	end
end
function DjListView:createSingle(data, index)
	local single = self.tableSingle[index]
	if single == nil then
		single = self.nodeClone:clone()
		single.labelName = SoraDGetChildByName(single, "Text_name")
		single.labelDes = SoraDGetChildByName(single, "Text_des")
		single.labelTime = SoraDGetChildByName(single, "Text_time")
		single.btnAttention = SoraDGetChildByName(single, "Button_attention")
		single.btnHead = SoraDGetChildByName(single, "Button_head")
		single.imgHead = SoraDGetChildByName(single, "Image_head")
		single.spriteLiving = SoraDGetChildByName(single, "Sprite_living")
		single.btnHead:addTouchEventListener(handler(self, self.btnClickCallBack))
		single.btnAttention:addTouchEventListener(handler(self, self.btnAttentionClickCallBack))
		single:addTo(self.scroll)
	end
	single.uid = data.uid
	single.labelName:setString(data.nick_name)
	single.labelDes:setString(data.anchor_sign)
	single.labelTime:setString(self:createTimeStr(data))
	single.btnHead:setTag(index)
	single.btnAttention:setTag(index)
	single.spriteLiving:setVisible(data.anchorLiving)
	SoraDGetHeadFromManager(single.imgHead, data.iconID, data.avatar)
	local isMe = include("chatFunctions"):getSelfId() == single.uid
	single.btnAttention:setTouchEnabled(not isMe)
	single.btnAttention:setBright(not isMe)
	single.isAttention = djCtrl:isAttentionDJ(single.uid)
	single.btnAttention:setTitleText(single.isAttention and i18n("Anchor_text_38") or i18n("Anchor_text_39"))
	single.btnAttention:loadTextures(single.isAttention and "btn_red_small_01.png" or "btn_green_small_01.png", "", "", ccui.TextureResType.plistType)
	self.tableSingle[index] = single
	single:setVisible(true)
	return single
end
function DjListView:createTimeStr(data)
	local str = ""
	local bt = string.format("%.2d:%.2d", math.floor(data.liveBTime / 3600), math.floor(data.liveBTime % 3600 / 60))
	local et = string.format("%.2d:%.2d", math.floor(data.liveETime / 3600), math.floor(data.liveETime % 3600 / 60))
	str = str .. bt .. "-" .. et
	return str
end
function DjListView:btnAttentionClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.djList[button:getTag()] and self.tableSingle[button:getTag()] then
			if self.tableSingle[button:getTag()].isAttention then
				djCtrl:sendDJAttentionCancel(self.djList[button:getTag()].uid)
			else
				djCtrl:sendDJAttention(self.djList[button:getTag()].uid)
			end
			SoraDShowLoading(self)
		end
	end
end
function DjListView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.djList[button:getTag()] then
			local panel = SoraDCreatePanel("djInfoView")
			panel:initData(self.djList[button:getTag()].uid)
			panel:show()
			self:removeFromParent()
		end
	end
end
return DjListView
