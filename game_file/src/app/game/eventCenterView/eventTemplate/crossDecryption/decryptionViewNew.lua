local crossDecryptionCtrl = SoraDGetCtrl("newCrossDecryptionCtrl")
local crossDecryptionRead = include("crossDecryptionRead")
local decryptionView = include("decryptionView")
local decryptionViewNew = class("decryptionViewNew", decryptionView)
function decryptionViewNew:ctor(...)
	decryptionViewNew.super.ctor(self, ...)
	self.ccs_title:setTitle(i18n("activity_name_9001525"))
	self.btn_help:addTouchEventListener(handler(self, self.btnRuleClick))
end
function decryptionViewNew:fitDevice(...)
	local dis = display.height - 960
	if 0 < dis then
		self.timeLabel:setPositionY(self.timeLabel:getPositionY() - 10)
		self.node_bottom_top:setPositionY(self.node_bottom_top:getPositionY() + 60)
		local bBSize = self.img_bottom_bg:getContentSize()
		self.img_bottom_bg:setContentSize(cc.size(bBSize.width, bBSize.height + 60))
		local fSize = self.img_bottom_frame:getContentSize()
		self.img_bottom_frame:setContentSize(cc.size(fSize.width, fSize.height + 60))
		local pSize = self.panel_sheer:getContentSize()
		self.panel_sheer:setContentSize(cc.size(pSize.width, pSize.height + dis))
		self.panel_alter:setPositionY(self.panel_alter:getPositionY() - 10)
		self.node_content:setPositionY(self.node_content:getPositionY() - dis / 2.5)
		self.img_bottom_sheer:setPositionY(self.img_bottom_sheer:getPositionY() - dis + 80)
	elseif dis == 0 then
		self.node_content:setPositionY(self.node_content:getPositionY() + 30)
	else
		self.node_bottom:setPositionY(-20)
		self.img_frame_top:setVisible(false)
		self.timeLabel:setPositionY(self.timeLabel:getPositionY() + 40)
		self.node_content:setPositionY(self.node_content:getPositionY() + 86)
		self.img_bottom_sheer:setPositionY(self.img_bottom_sheer:getPositionY() - dis)
	end
	local Image_2 = SoraDGetChildByName(self, "Image_2")
	local h = display.height - 302
	local scale = math.max(1, h / Image_2:getContentSize().height)
	Image_2:setScale(scale)
end
function decryptionViewNew:createRowAndLineAnimation(...)
end
function decryptionViewNew:createSingleItem(data, idx)
	local itemSingle = self.node_single_item:clone()
	itemSingle.text_idx = SoraDGetChildByName(itemSingle, "Text_index")
	itemSingle.text_idx:setString(tostring(idx))
	itemSingle.node_line = SoraDGetChildByName(itemSingle, "Node_line")
	itemSingle.node_first = SoraDGetChildByName(itemSingle, "Node_first")
	itemSingle.touchBtn = SoraDGetChildByName(itemSingle, "Image_touch")
	itemSingle.touchBtn:setTouchEnabled(true)
	itemSingle.touchBtn:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			local panel = SoraDCreatePanel("decryptionPopView")
			panel:initData(data, crossDecryptionCtrl, crossDecryptionRead)
			panel:show()
		end
	end)
	function itemSingle:setTaskCanReceive(_bool)
		if _bool then
			if not itemSingle.effect1 then
				local effect = SoraDCreatAnimation("Node_Effect_hzlhsdb01")
				SoraDMixtureGLONEByParent(effect)
				effect:addTo(itemSingle.node_first)
				effect:setPosition(0, 10)
				itemSingle.effect1 = effect
			end
			itemSingle.effect1:setVisible(_bool)
		elseif itemSingle.effect1 then
			itemSingle.effect1:setVisible(_bool)
		end
	end
	itemSingle:addTo(self.node_items)
	return itemSingle
end
function decryptionViewNew:commitTaskAnimation(data)
	if self.taskTable[tostring(data.taskID)] then
		local single = self.taskTable[tostring(data.taskID)]
		single.touchBtn:setTouchEnabled(false)
		single.node_first:setVisible(false)
		local effect = SoraDCreatAnimation("Node_Effect_hzlhsdb02", nil, false)
		SoraDMixtureGLONEByParent(effect)
		effect:addTo(single)
		self:initData()
		_ENV = single
		single[tostring(data.taskID)] = data
		self:refleshSingleView(single)
	end
end
function decryptionViewNew:setBoxSpriteFrame(itemBox, open)
	local box = itemBox.spriteBox
	local canReceived = crossDecryptionCtrl:checkCurBoxStatus(itemBox:getTag())
	if canReceived then
		box:setVisible(false)
		if not itemBox.effect3 then
			local effect = SoraDCreatAnimation("Node_Effect_hzlhsdb03")
			SoraDMixtureGLONEByParent(effect)
			effect:addTo(itemBox)
			effect:setPosition(0, -17)
			itemBox.effect3 = effect
		end
		itemBox.effect3:setVisible(true)
	else
		box:setVisible(true)
		if open then
			box:setSpriteFrame("frame_hzlh_wz_01.png")
		else
			box:setSpriteFrame("frame_hzlh_wz_02.png")
		end
		if itemBox.effect3 then
			itemBox.effect3:setVisible(false)
		end
	end
end
function decryptionViewNew:btnRuleClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "activity_name_9001525"
		;("activity_name_9001525")[1] = i18n("decrypt_text_04")
		;("activity_name_9001525")[2] = i18n("decrypt_text_04")
		SoraDShowFixWindow(i18n("activity_name_9001525"), "activity_name_9001525")
	end
end
return decryptionViewNew
