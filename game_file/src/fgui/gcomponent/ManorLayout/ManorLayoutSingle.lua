local manorLayoutCtrl = SoraDGetCtrl("manorLayoutCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ManorLayoutSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorLayout/ManorLayoutSingle", ManorLayoutSingle)
function ManorLayoutSingle:onInit()
	self.fields.Button_like:addClickListener(handler(self, self.onClick_Button_like))
	self.fields.Com_mapLayout:addClickListener(handler(self, self.onClickMapLayout))
end
function ManorLayoutSingle:onShow()
end
function ManorLayoutSingle:onClick_Button_like(context)
	SoraDPlaySound()
	local uid = self.layoutData.uid or 0
	local iid = self.layoutData.id or 0
	local isLike = self:getSelfIsLike(self.layoutData)
	if isLike then
		manorLayoutCtrl:reqUnlike(uid, iid)
	else
		manorLayoutCtrl:reqLike(uid, iid)
	end
end
function ManorLayoutSingle:initData(layoutData, player)
	self.layoutData = layoutData
	self.player = player
	if not layoutData.map then
		local _ENV, map = layoutData.map, layoutData.map
	end
	self.fields.Com_mapLayout:initLayoutMap(map)
	self.fields.Com_head:setHeadSprite(player.iconID, player.avatar)
	local nickName = player.nickName or ""
	_ENV = player.avatar
	player.avatar.name = nickName
	local nameStr = i18n("Socialize_text_12", player.avatar)
	self.fields.Text_name:setString(nameStr)
	self:updateButtonLike()
end
function ManorLayoutSingle:updateButtonLike(layoutData)
	if layoutData then
		self.layoutData = layoutData
	end
	local likeCount = self.layoutData.likeCount or 0
	self.fields.Button_like:setString(tostring(likeCount))
	local isLike = self:getSelfIsLike(self.layoutData)
	self.fields.Button_like:setGrayed(not isLike)
end
function ManorLayoutSingle:getSelfIsLike(layoutData)
	if not layoutData.likeUserMap then
		local _ENV, likeUserMap = layoutData.likeUserMap, layoutData.likeUserMap
	end
	local selfUid = SoraDGetPlayerID()
	local isLike = likeUserMap[tostring(selfUid)] or false
	return isLike
end
function ManorLayoutSingle:onClickMapLayout(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).layoutData = self.layoutData
	;(nil).player = self.player
	uiManager:show("ManorLayoutPreview", nil)
end
return ManorLayoutSingle
