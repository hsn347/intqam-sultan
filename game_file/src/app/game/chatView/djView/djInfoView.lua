local djCtrl = SoraDGetCtrl("djCtrl")
local DjInfoView = class("djInfoView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("djInfoView")
	end
	return target
end)
function DjInfoView:ctor()
	self.data, _ENV, self.djuid = nil, nil, 0
	self.isAttention = false
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.layerCut = SoraDGetChildByName(self, "Panel_cut")
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.btnTime = SoraDGetChildByName(self, "Button_time")
	self.btnAttention = SoraDGetChildByName(self, "Button_attention")
	self.labelFans = SoraDGetChildByName(self, "Text_fans")
	self.labelPopularity = SoraDGetChildByName(self, "Text_popularity")
	self.labelSlogan = SoraDGetChildByName(self, "Text_slogan")
	self.labelFans = SoraDChangeTextToHtml(self.labelFans)
	self.labelPopularity = SoraDChangeTextToHtml(self.labelPopularity)
	self.labelSlogan = SoraDChangeTextToHtml(self.labelSlogan)
	self.btnTime:setTitleText(i18n("Anchor_text_37"))
	self.btnTime:addTouchEventListener(handler(self, self.btnTimeClickCallBack))
	self.btnAttention:addTouchEventListener(handler(self, self.btnAttentionClickCallBack))
	SoraDAutoSizeButtonText(self.btnTime)
	SoraDAutoSizeButtonText(self.btnAttention)
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_ATTENTION_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BIG_HEAD", function(target, data)
		print("receive msg")
		if data.avatar == self.avatar then
			self:updateBigHead(self.headid, self.avatar)
		end
	end)
end
function DjInfoView:initData(uid)
	self.djuid = uid
	self:updateView()
end
function DjInfoView:updateView()
	self.data = djCtrl:getDJInfo(self.djuid)
	if next(self.data) == nil then
		self:removeFromParent()
		return
	end
	local numColor = cc.c3b(200, 170, 150)
	djCtrl = nil
	djCtrl, djCtrl, (nil).num = self.data.attentionNum, string.formatnumberthousands(self.data.attentionNum), string.formatnumberthousands(self.data.attentionNum)
	string.formatnumberthousands(self.data.attentionNum).num, self.data.attentionNum.color = self.data.attentionNum, numColor
	self.labelFans:setString(i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum))))
	djCtrl = i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum)))
	djCtrl, djCtrl, i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum))).num = self.data.contributeCount, string.formatnumberthousands(self.data.contributeCount), string.formatnumberthousands(self.data.contributeCount)
	string.formatnumberthousands(self.data.contributeCount).num, self.data.contributeCount.color = self.data.contributeCount, numColor
	self.labelPopularity:setString(i18n_html("Anchor_text_52", i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum)))))
	djCtrl = i18n_html("Anchor_text_52", i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum))))
	djCtrl, djCtrl, i18n_html("Anchor_text_52", i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum)))).name = i18n_html("Anchor_text_52", i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum))))
	self.data.anchor_sign.name, i18n_html("Anchor_text_52", i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum)))).color = i18n_html("Anchor_text_52", i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum))))
	self.labelSlogan:setString(i18n_html("Anchor_text_53", i18n_html("Anchor_text_52", i18n_html("Anchor_text_51", nil, (string.formatnumberthousands(self.data.attentionNum))))))
	self.nodeTitle:setTitleName(self.data.nick_name)
	self:updateBigHead(self.data.iconID, self.data.avatar)
	self.isAttention = djCtrl:isAttentionDJ(self.djuid)
	local isMe = include("chatFunctions"):getSelfId() == self.data.uid
	self.btnAttention:setTouchEnabled(not isMe)
	self.btnAttention:setBright(not isMe)
	self.btnAttention:setTitleText(self.isAttention and i18n("Anchor_text_38") or i18n("Anchor_text_39"))
	self.btnAttention:loadTextures(self.isAttention and "btn_red_normal_01.png" or "btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	SoraDCloseLoading(self)
end
function DjInfoView:updateBigHead(headid, avatar)
	self.avatar = avatar
	self.headid = headid
	if self.avatar and self.avatar ~= "" then
		if SoraDHasHeadFromManager(self.avatar, true) then
			SoraDGetHeadFromManager(self.imgHead, self.headid, self.avatar, true)
		else
			SoraDGetHeadFromManager(self.imgHead, self.headid, self.avatar)
			SoraDPlayerHeadDownload(self.avatar, true)
		end
	end
end
function DjInfoView:btnTimeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("djListView"):show()
		self:removeFromParent()
	end
end
function DjInfoView:btnAttentionClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isAttention then
			djCtrl:sendDJAttentionCancel(self.djuid)
		else
			djCtrl:sendDJAttention(self.djuid)
		end
		SoraDShowLoading(self)
	end
end
return DjInfoView
