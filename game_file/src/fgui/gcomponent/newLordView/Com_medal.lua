local achiDesRead = include("achiDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_medal = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://newLordView/Com_medal", Com_medal)
function Com_medal:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_medal:onShow()
end
function Com_medal:initData(data, isShowEffect, isOther)
	self.data = data
	_UPVALUE4_, self.isOther = nil, isOther
	;(nil)[1] = self.data.medalID
	;(nil)[2] = self.data.star
	;(nil)[3] = isShowEffect
	local (nil)[4], dataTable = isOther, nil
	if self.lastDataTable ~= nil then
		local isDiff = false
		for i, v in ipairs(self.lastDataTable) do
			isDiff = isDiff or v ~= dataTable[i]
		end
		if not isDiff then
			return
		end
	end
	self.lastDataTable = dataTable
	local medalInfo = achiDesRead.getMedalById(self.data.medalID)
	local isGray = self.data.star < MEDAL_MIN_STAR_SHOW
	local spriteAchi = achiDesRead.getShowMedalNode(self.data.medalID, self.data.medalID, self.data.star, isShowEffect, isOther)
	if isGray then
		self.fields.Text_medalName:setString("???")
		self.fields.Text_medalName:setColor(cc.c3b(120, 120, 120))
	else
		self.fields.Text_medalName:setString(i18n(medalInfo.medalName))
		self.fields.Text_medalName:setColor(cc.c3b(255, 251, 213))
	end
	spriteAchi:setPosition(100, 100)
	spriteAchi:hideName()
	spriteAchi:bindClick()
	spriteAchi:setAchiListModelPosY()
	self.fields.achi:clearContent()
	self.fields.achi:setContent(spriteAchi)
end
function Com_medal:btnClick()
	SoraDPlaySound("uicontrol", 31)
	if self.isOther then
		if self.data.star >= MEDAL_MIN_STAR_SHOW then
			SoraDShowMsgTip(achiDesRead.getBuffStrByID(self.data.id, self.data.star))
		end
		return
	end
	if self.data.star < MEDAL_MIN_STAR_SHOW then
		_ENV = achiDesRead.getBuffStrByID(self.data.id, self.data.star)
		achiDesRead.getBuffStrByID(self.data.id, self.data.star).myIconData = self.data
		uiManager:show("achiToMedalPopView", achiDesRead.getBuffStrByID(self.data.id, self.data.star))
		return
	end
	if self.data.isActive then
		if self.data.onWork then
			_ENV = achiDesRead.getBuffStrByID(self.data.id, self.data.star)
			achiDesRead.getBuffStrByID(self.data.id, self.data.star).myIconData = self.data
			achiDesRead.getBuffStrByID(self.data.id, self.data.star).isWork = false
			uiManager:show("medalPopView", achiDesRead.getBuffStrByID(self.data.id, self.data.star))
		else
			_ENV = achiDesRead.getBuffStrByID(self.data.id, self.data.star)
			achiDesRead.getBuffStrByID(self.data.id, self.data.star).myIconData = self.data
			achiDesRead.getBuffStrByID(self.data.id, self.data.star).isWork = true
			uiManager:show("medalPopView", achiDesRead.getBuffStrByID(self.data.id, self.data.star))
		end
	else
		_ENV = achiDesRead.getBuffStrByID(self.data.id, self.data.star)
		achiDesRead.getBuffStrByID(self.data.id, self.data.star).myIconData = self.data
		achiDesRead.getBuffStrByID(self.data.id, self.data.star).isWork = false
		uiManager:show("medalPopView", achiDesRead.getBuffStrByID(self.data.id, self.data.star))
	end
end
return Com_medal
