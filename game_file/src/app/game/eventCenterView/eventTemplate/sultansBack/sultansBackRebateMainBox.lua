local sultansBackRebateUtil = include("sultansBackRebateUtil")
local AWARD_STATUES = sultansBackRebateUtil.AWARD_STATUES
local sultansBackRebateMainBox = class("sultansBackRebateMainBox", function(target)
	return target
end)
function sultansBackRebateMainBox:ctor()
	self.btnBox = SoraDGetChildByName(self, "Button_box")
	self.txtNum = SoraDGetChildByName(self, "Text_num")
	self.spBox = SoraDGetChildByName(self, "Sprite_box")
	self.spGet = SoraDGetChildByName(self, "Sprite_get")
	self.nodeEffect = SoraDGetChildByName(self, "Node_effect")
	self.btnBox:addTouchEventListener(handler(self, self.onClickBox))
	self.initEffect = false
end
function sultansBackRebateMainBox:initView(info)
	self.info = info
	local str = string.formatnumberthousands(info.score)
	self.txtNum:setString(str)
	local img = sultansBackRebateUtil.getBoxImg(info.round)
	self.spBox:setSpriteFrame(img)
end
function sultansBackRebateMainBox:updateView()
	self:updateBoxStatus()
end
local CORLOR_GREY = cc.c3b(120, 120, 120)
local CORLOR_NORMAL = cc.c3b(255, 255, 255)
function sultansBackRebateMainBox:updateBoxStatus()
	local statues = sultansBackRebateUtil.getRoundStatues(self.info)
	if statues == AWARD_STATUES.AWARD_STATUES_COMPLETE then
		if not self.initEffect then
			self.initEffect = true
		end
		self.nodeEffect:setVisible(true)
	else
		self.nodeEffect:setVisible(false)
	end
	local isGet = statues == AWARD_STATUES.AWARD_STATUES_GET
	local color = isGet and CORLOR_GREY or CORLOR_NORMAL
	self.spGet:setVisible(isGet)
	self.spBox:setColor(color)
end
function sultansBackRebateMainBox:onClickBox(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("sultansBackRebateAwardView")
		panel:show()
		panel:initViewBox(self.info)
	end
end
return sultansBackRebateMainBox
