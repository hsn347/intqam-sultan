local publicRead = include("publicRead")
local effectUI = include("effectUI")
local nodeReward = class("nodeReward", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeReward")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function nodeReward:ctor()
	self:createUI()
	self.Node_Content = SoraDGetChildByName(self, "Node_Content")
	self.bg = SoraDGetChildByName(self, "bg")
	self.icon = SoraDGetChildByName(self, "icon")
	self.frame = SoraDGetChildByName(self, "frame")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.bg:setLocalZOrder(-2)
	self.bg:setTouchEnabled(true)
	self.bg:addTouchEventListener(handler(self, self.onClick_show))
end
function nodeReward:createUI()
end
function nodeReward:init(data)
	local itemId = data.id
	local itemNum = data.count
	self.bg:loadTexture(publicRead.getBg(itemId), ccui.TextureResType.plistType)
	self.icon:loadTexture(publicRead.getIcon(itemId), ccui.TextureResType.plistType)
	local itemName = publicRead.getName(itemId)
	publicRead = nil
	;(nil).name = itemName
	;(nil).count = string.formatnumberthousands(itemNum)
	self.text_name:setString(i18n("common_text_1460", nil))
	self.bg.itemId = itemId
end
function nodeReward:onMessageListener()
end
function nodeReward:onClick_show(sender, event)
	if event == ccui.TouchEventType.began then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll, event) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		self:openItemInfo(sender.itemId, sender)
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
		self:closeItemInfo()
	elseif event == ccui.TouchEventType.ended then
		self:closeItemInfo()
	end
end
function nodeReward:openItemInfo(id, sender)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDKING_SHOW_ITEMINFO"
	;(nil).isShow = true
	;(nil).id = id
	;(nil).item = sender
	SoraDSendMessage(nil)
end
function nodeReward:closeItemInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDKING_SHOW_ITEMINFO"
	;(nil).isShow = false
	SoraDSendMessage(nil)
end
function nodeReward:showGlow()
	if not self.glow1 then
		self.glow1, self.glow2 = effectUI.getItemEffect()
		self.glow1:addTo(self)
		self.glow1:setScale(1.2)
		self.glow1:setPosition(cc.p(60, 98))
		self.glow1:setLocalZOrder(-1)
		self.glow1:setScale(0.75)
		self.glow2:addTo(self)
		self.glow2:setScale(1.2)
		self.glow2:setPosition(cc.p(60, 98))
		self.glow2:setLocalZOrder(1)
		self.glow2:setScale(1)
	end
end
function nodeReward:removeGlow()
	if self.glow1 then
		self.glow1:removeFromParent()
		self.glow1 = nil
	end
	if self.glow2 then
		self.glow2:removeFromParent()
		self.glow2 = nil
	end
end
return nodeReward
