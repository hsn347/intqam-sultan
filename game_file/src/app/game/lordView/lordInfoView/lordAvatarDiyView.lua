local LordAvatarDiyView = class("lordAvatarDiyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("lordAvatarDiyView")
	end
	return target
end)
function LordAvatarDiyView:ctor()
	self:setBackGround(0)
	self:setSwallowTouches(false)
	self.avatar = ""
	self.headid = 0
	self.labelContent = SoraDGetChildByName(self, "content")
	self.labelContent:setString(i18n("game_avatar_select_warning_info"))
	self.Text_1 = SoraDGetChildByName(self, "Text_1")
	if self.Text_1 then
		self.Text_1:setString(i18n("game_avatar_select_attention_info"))
	end
	self.btnPhoto = SoraDGetChildByName(self, "btn_photo")
	self.btnPhoto:setTitleText(i18n("game_take_photo_button"))
	self.btnLibrary = SoraDGetChildByName(self, "btn_library")
	self.btnLibrary:setTitleText(i18n("game_choose_from_library_button"))
	self.btnPhoto:addTouchEventListener(handler(self, self.btnPhotoCallBack))
	self.btnLibrary:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_AVATAR_UPLOAD_SUCCESS", handler(self, self.uploadCallBack))
	self.btnPhoto:setVisible(not SoraDIsGooglePlayGamePC())
end
function LordAvatarDiyView:btnPhotoCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.captureAvatar()
	end
end
function LordAvatarDiyView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.pickAvatar()
	end
end
function LordAvatarDiyView:uploadCallBack()
	self:closePanel()
end
return LordAvatarDiyView
