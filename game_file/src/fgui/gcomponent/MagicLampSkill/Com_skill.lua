local magicLampSkillRead = include("magicLampSkillRead")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_skill = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_skill", Com_skill)
function Com_skill:onInit()
	self.isLong = false
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickListener(handler(self, self.onClickBtnSkill))
	self.fields.Text_get:setString(i18n("jinn_skill_62"))
	self.fields.MovieClip_js:setAllFrameName("dh_sdsl_js_%02d.png", 1)
	self.fields.MovieClip_zs:setAllFrameName("dh_sdsl_zs_%02d.png", 1)
end
function Com_skill:onShow()
end
function Com_skill:onLongPress(...)
	if self.longPressHandle then
		self.isLong = true
		SoraDPlaySound()
		self.longPressHandle(self)
	end
end
function Com_skill:onClickBtnSkill(...)
	if self.isLong then
		self.isLong = false
		return
	end
	if self.clickHandle then
		SoraDPlaySound()
		self.clickHandle(self)
	else
		if self.isClickShowDetail then
			_ENV = nil
			;(nil).data = self.data
			uiManager:show("MagicLampSkillDetailsLook", nil)
		end
		if self.isHandbookView then
			SoraDPlaySound()
			_ENV = nil
			;(nil).skillType = self.data.skillType
			uiManager:show("MagicLampSkillDetails", nil)
		end
	end
end
function Com_skill:initData(data)
	self.data = data
	magicLampSkillCtrl:initSkillBase(self.fields, data)
	local quality = magicLampSkillRead.getSkillQuality(data.skillType)
	self.quality = quality
	self.fields.Load_bg:setURL(magicLampSkillRead.getQualityFrame(quality))
	if quality == 3 or quality == 4 then
		self.controllers.c_effect:setSelectedIndex(quality - 2)
	else
		self.controllers.c_effect:setSelectedIndex(0)
	end
	if data.lock then
		self.controllers.c_lock:setSelectedIndex(1)
	else
		self.controllers.c_lock:setSelectedIndex(0)
	end
	self.controllers.c_using:setSelectedIndex(0)
	if data.id then
		local isUsing, __, jinnType = magicLampCtrl:getIsUsing(data.id)
		if isUsing then
			self.controllers.c_using:setSelectedIndex(1)
			local jinnName = magicLampRead.getJinnName(jinnType)
			magicLampSkillCtrl = magicLampSkillRead.getQualityFrame(quality)
			magicLampSkillRead.getQualityFrame(quality).color = "#FFFFFF"
			self.fields.Text_using:setString(SoraDWrapHtmlTagByStyle(jinnName, magicLampSkillRead.getQualityFrame(quality)) .. "\n" .. i18n("privilege_text_130"))
		end
	end
end
function Com_skill:initByType(skillType)
	_UPVALUE0_ = nil
	local (nil).skillType, data = skillType, nil
	self:initData(data)
end
function Com_skill:setClickHandle(handle)
	self.clickHandle = handle
end
function Com_skill:setLongPressHandle(handle)
	self.longPressHandle = handle
end
function Com_skill:setSelectViewData(data)
	self.isSelectView = true
	self.controllers.c_state:setSelectedIndex(1)
	self:initData(data)
	if self.data.lv and 1 < self.data.lv or self.data.classLv and self.data.classLv > 0 then
		self.controllers.c_mark:setSelectedIndex(1)
	else
		self.controllers.c_mark:setSelectedIndex(0)
	end
end
function Com_skill:setIsSelect(isSelect)
	self.fields.Button_choose:setSelected(isSelect)
	self.fields.Image_black:setVisible(isSelect)
end
function Com_skill:setHandbookView()
	self.isHandbookView = true
	self:updateGetState(magicLampSkillCtrl:checkHasSkill(self.data.skillType))
end
function Com_skill:setClickShowDetail()
	self.isClickShowDetail = true
end
function Com_skill:updateGetState(isGet)
	if not isGet then
		self.controllers.c_state:setSelectedIndex(2)
	else
		self.controllers.c_state:setSelectedIndex(0)
	end
end
function Com_skill:setQualityEffect(isShow)
	if isShow and (self.quality == 3 or self.quality == 4) then
		self.controllers.c_effect:setSelectedIndex(self.quality - 2)
	else
		self.controllers.c_effect:setSelectedIndex(0)
	end
end
return Com_skill
