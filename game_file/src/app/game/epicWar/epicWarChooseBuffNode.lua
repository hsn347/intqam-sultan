local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarChooseBuffNode = class("epicWarChooseBuffNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicWarChooseBuffNode")
	end
	return target
end)
function epicWarChooseBuffNode:ctor()
	self.handle = nil
	self.idx = nil
	self.strategyId = nil
	self.Image_buff = SoraDGetChildByName(self, "Image_buff")
	self.Image_buff:setVisible(false)
	self.Image_base = SoraDGetChildByName(self, "Image_base")
	self.Image_base:setVisible(false)
	self.Button_touch = SoraDGetChildByName(self, "Button_touch")
	self.Button_touch:setTouchEnabled(false)
	self.Button_touch:addTouchEventListener(handler(self, self.btnTouchClick))
end
function epicWarChooseBuffNode:initData(index, idx, strategyId)
	self.index = index
	self.idx = idx
	self.strategyId = strategyId
	if self.strategyId then
		self.Image_buff:setVisible(true)
		self.Image_base:setVisible(true)
		self.Button_touch:setTouchEnabled(true)
		local icon = epicWarltCtrl.getTacticsIcon(self.strategyId)
		self.Image_buff:loadTexture(icon, ccui.TextureResType.plistType)
		local base = epicWarltCtrl.getTacticsIconBase(self.strategyId)
		self.Image_base:loadTexture(base, ccui.TextureResType.plistType)
	else
		self.Image_buff:setVisible(false)
		self.Image_base:setVisible(false)
		self.Button_touch:setTouchEnabled(false)
	end
end
function epicWarChooseBuffNode:setHandle(handle)
	self.handle = handle
end
function epicWarChooseBuffNode:btnTouchClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle and self.idx and self.strategyId then
			self.handle(self.index, self.idx, self.strategyId)
		end
	end
end
return epicWarChooseBuffNode
