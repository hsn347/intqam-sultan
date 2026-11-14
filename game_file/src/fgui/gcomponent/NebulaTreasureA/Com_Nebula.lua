local publicRead = include("publicRead")
local nebulaExplorationCtrl = include("nebulaExplorationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Nebula = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NebulaTreasureA/Com_Nebula", Com_Nebula)
function Com_Nebula:onInit()
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickListener(handler(self, self.onClick))
end
function Com_Nebula:onShow()
end
function Com_Nebula:initData(index, costNum, award, handle)
	self.index = index
	self.handle = handle
	self.costNum = costNum
	self:setString(costNum)
	self.fields.icon_Need:setURL(publicRead.getIcon(include("constantRead").getConstValue("NEBULA_TREASURE_CONSUME_ITEM", 864801)))
	self.id = nil
	if award then
		self.id = award.id
		self.num = award.count
		self.fields.Text_ItemNum:setString(string.formatnumberthousands(self.num))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Image_icon:setURL(publicRead.getIcon(self.id))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_Nebula:onLongPress(button, startPos)
	if not self.id then
		return
	end
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
function Com_Nebula:onClick()
	if self.id then
		return
	end
	if self.isLong then
		self.isLong = false
		return
	end
	SoraDPlaySound()
	if self.handle then
		self.handle(self.index)
	end
end
function Com_Nebula:showEffect(award)
	self.fields.Usm_5:play(false)
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.delay(0.5)
	;(nil)[2] = ffa.callFunc(function()
		self.id = nil
		if award then
			self.id = award.id
			self.num = award.count
			self.fields.Text_ItemNum:setString(string.formatnumberthousands(self.num))
			self.controllers.c1:setSelectedIndex(1)
			self.fields.Image_icon:setURL(publicRead.getIcon(self.id))
		else
			self.controllers.c1:setSelectedIndex(0)
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
return Com_Nebula
