local mailItemDetailFightDefense = class("mailItemDetailFightDefense", function(target)
	if target == nil then
		return SoraDCreateBasePanel("mailItemDetailFightDefense")
	end
	return target
end)
function mailItemDetailFightDefense:ctor()
	self.isHidePrePanel = false
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_mail")
	self.title:setTitle(i18n("mail_text_25"))
	self.fdScrollView = SoraDGetExtendChildFromCCSByName(self, "CCS_mailItemDetailFDScrollView_node", true)
	self:fitView()
	SoraDTestButton(self, function()
		if self.data and self.data.fightDetail then
			SoraDCopyText(self.data.fightDetail)
			SoraDShowMsgTip(i18n("common_text_1062"))
		end
	end, nil, i18n("common_text_078"))
end
function mailItemDetailFightDefense:initWithData(data, strTime)
	self.data = data
	self.title:setTitle(i18n("common_text_019"))
	self.fdScrollView:cleanInnerContents()
	self.fdScrollView:initWithData(data, strTime)
end
function mailItemDetailFightDefense:initWithFightDetail(data, title)
	self.data = data
	self.title:setTitle(title or i18n("mail_text_01"))
	self.fdScrollView:cleanInnerContents()
	self.fdScrollView:initWithFightDetail(data)
end
function mailItemDetailFightDefense:fitView()
end
function mailItemDetailFightDefense:closeView(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
return mailItemDetailFightDefense
