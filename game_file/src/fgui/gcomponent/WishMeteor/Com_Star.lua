local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local wishingMeteorRead = include("wishingMeteorRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Star = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WishMeteor/Com_Star", Com_Star)
function Com_Star:onInit()
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickListener(handler(self, self.onClick))
	self.fields.movie_Color:setAllFrameName("dh_Tex_XL_lxxy01_0%02d.png", 0)
end
function Com_Star:onShow()
end
function Com_Star:onLongPress(button, startPos, endPos)
	self.isLong = true
	SoraDPlaySound()
	print("self.itemId ====== ", self.id)
	_ENV = "self.itemId ====== "
	;("self.itemId ====== ").msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;("self.itemId ====== ").id = self.id
	;("self.itemId ====== ").num = self.num
	;("self.itemId ====== ").pos = startPos
	;("self.itemId ====== ").customName = self.customName
	;("self.itemId ====== ").customTip = self.customTip
	SoraDSendMessage("self.itemId ====== ")
end
function Com_Star:onClick()
	if self.isLong then
		self.isLong = false
		return
	end
	if not self.id and self.clickCallback then
		SoraDPlaySound()
		self.clickCallback(self)
	end
end
function Com_Star:setClickCallback(callback)
	self.clickCallback = callback
end
function Com_Star:initData(index, id)
	self.id = id
	self.controllers.c1:setSelectedIndex(id and 1 or 0)
	if id then
		self.fields.icon:setURL(publicRead.getIcon(id))
		local quality = itemDesRead.getQuality(id)
		self.num = wishingMeteorRead.getCountById(index, id)
		self.fields.Text_Num:setString(self.num)
	else
		self.fields.icon:setURL("img_baoshi_+.png")
	end
end
function Com_Star:showEffect(index, id)
	self.fields.Usm_5:play(false)
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.delay(0.5)
	;(nil)[2] = ffa.callFunc(function()
		if index then
			self:initData(index, id)
		end
	end)
	;(nil)[3] = ffa.delay(1)
	;(nil)[4] = ffa.callFunc(function()
		self.fields.Usm_5:setVisible(false)
	end)
	;(nil)[5] = ffa.callFunc(function()
		self.fields.Usm_5:setVisible(false)
	end)
	self:runAction(ffa.seq(nil))
end
return Com_Star
