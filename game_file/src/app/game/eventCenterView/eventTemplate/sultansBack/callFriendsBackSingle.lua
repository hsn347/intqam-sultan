local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local callFriendsBackSingle = class("callFriendsBackSingle", function(target)
	return SoraDCreateBasePanel("callFriendsBackSingle")
end)
function callFriendsBackSingle:ctor()
	self.Text_index = SoraDGetChildByName(self, "Text_index")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_alliance = SoraDGetChildByName(self, "Text_alliance")
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.ccs_head:setScale(0.8)
end
function callFriendsBackSingle:initData(data, otherData)
	dump(data, "data=======")
	self.ccs_head:setHeadSprite(data.imageId, data.avatar)
	self.ccs_head:setPlayerID(data.uid)
	self.ccs_head:setTouchEnabled(false)
	self.Text_index:setString(data.index)
	self.Text_name:setString(data.nickName)
	_ENV = nil
	;(nil).kid = data.kid
	self.Text_alliance:setString(i18n("common_text_342", nil))
end
return callFriendsBackSingle
