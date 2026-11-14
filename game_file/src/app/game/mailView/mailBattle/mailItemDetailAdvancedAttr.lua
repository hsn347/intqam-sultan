local mailDesParser = include("mailDesParser")
local mailItemDetailAdvancedAttr = class("mailItemDetailAdvancedAttr", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("mailItemDetailAdvancedAttr")
end)
function mailItemDetailAdvancedAttr:ctor(properties)
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_mail")
	self.title:setTitleSize()
	self.detailScrollView = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_mailItemDetailScrollView_node")
	self:fitView()
end
function mailItemDetailAdvancedAttr:fitView()
	self.detailScrollView:resetContentSize(cc.size(640, self.detailScrollView:getContentSize().height + 100))
end
function mailItemDetailAdvancedAttr:initData(mail)
	local mailTitle = mailDesParser.getMailTitle(mail)
	self.title:setTitle(mailTitle)
	self.detailScrollView:cleanInnerContents()
	self.detailScrollView:initWithData(mail, nil, 1)
end
function mailItemDetailAdvancedAttr:initWithFightDetail(mail)
	self.title:setTitle(i18n("common_text_122"))
	self.detailScrollView:cleanInnerContents()
	self.detailScrollView:initWithData(mail, nil, 2)
end
function mailItemDetailAdvancedAttr:closeView(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
return mailItemDetailAdvancedAttr
