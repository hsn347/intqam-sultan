local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local MaterialsListView = class("materialsListView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("materialsListView")
	end
	return target
end)
function MaterialsListView:ctor()
	self:setBackGround(0)
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.tableSingleData, _ENV, self.type = gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL
	self.handle = nil
	self.openCompoundView = false
	self.jumpHandle = nil
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.layerBg = SoraDGetChildByName(self, "Panel_bg")
	self.imgBlack = SoraDGetChildByName(self, "Image_black")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setVisible(false)
	self.labelNotice:setString(i18n("common_text_1412"))
	self.scrollMaterial = SoraDGetChildByName(self, "ScrollView_material")
	self.scrollMaterial:addEventListener(handler(self, self.scrollEventCallBack))
	self.spriteLeft = SoraDGetChildByName(self, "Sprite_left")
	self.spriteRight = SoraDGetChildByName(self, "Sprite_right")
	self.equipPop = SoraDCreatePanel("equipPopShowView")
	self.equipPop:addTo(self.centerNode, 2)
	self.equipPop:setVisible(false)
	self.labelTitle:setVisible(false)
	self.spriteLeft:setVisible(false)
	self.spriteRight:setVisible(false)
	_UPVALUE1_ = handler(self, self.scrollEventCallBack)
	handler(self, self.scrollEventCallBack)[1] = cca.moveBy(0.8, 10, 0)
	handler(self, self.scrollEventCallBack)[2] = cca.moveBy(0.8, -10, 0)
	handler(self, self.scrollEventCallBack)[3] = cca.moveBy(0.8, -10, 0)
	handler(self, self.scrollEventCallBack)[4] = cca.moveBy(0.8, -10, 0)
	handler(self, self.scrollEventCallBack)[5] = cca.moveBy(0.8, -10, 0)
	self.spriteLeft:runAction(cca.repeatForever(cca.seq(handler(self, self.scrollEventCallBack))))
	_UPVALUE1_ = cca.repeatForever(cca.seq(handler(self, self.scrollEventCallBack)))
	cca.repeatForever(cca.seq(handler(self, self.scrollEventCallBack)))[1] = cca.moveBy(0.8, -10, 0)
	cca.repeatForever(cca.seq(handler(self, self.scrollEventCallBack)))[2] = cca.moveBy(0.8, 10, 0)
	cca.repeatForever(cca.seq(handler(self, self.scrollEventCallBack)))[3] = cca.moveBy(0.8, 10, 0)
	cca.repeatForever(cca.seq(handler(self, self.scrollEventCallBack)))[4] = cca.moveBy(0.8, 10, 0)
	cca.repeatForever(cca.seq(handler(self, self.scrollEventCallBack)))[5] = cca.moveBy(0.8, 10, 0)
	self.spriteRight:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(handler(self, self.scrollEventCallBack))))))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateDataBySelf))
end
function MaterialsListView:updateDataBySelf()
	if self.type == gEquipMaterialType.MATERIAL then
		for i, v in ipairs(self.tableSingleData) do
			local count = backpackCtrl:getItemCount(v.mid)
			self.tableSingleData[i].count = count
		end
		self:initData(self.type, self.tableSingleData)
	end
end
function MaterialsListView:initData(type, dataList, target)
	self.type = type
	self.tableSingleData = dataList
	if target then
		local touchEndPoint = target:getTouchEndPosition()
		showY = touchEndPoint.y - 50
		if showY < 200 then
			showY = 200
		end
		self.centerNode:setPositionY(showY)
	end
	if self.type == gEquipMaterialType.EQUIP and #self.tableSingleData <= 0 then
		self.labelNotice:setVisible(true)
	else
		self.labelNotice:setVisible(false)
	end
	self:initScrollSize()
end
function MaterialsListView:setTitle(txt)
	self.labelTitle:setString(txt)
	self.labelTitle:setVisible(true)
end
function MaterialsListView:updateData(dataList)
	self.tableSingleData = dataList
	self:initScrollSize()
end
function MaterialsListView:initScrollSize()
	local totalW = math.max(self.scrollMaterial:getContentSize().width, 108 * #self.tableSingleData)
	self.scrollMaterial:setInnerContainerSize(cc.size(totalW, self.scrollMaterial:getContentSize().height))
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
		end
		v.point = nil
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	for i, v in ipairs(self.tableSingleData) do
		_ENV = v.point
		v.point.data = v
		v.point.point = nil
		v.point.posX = SoraDFPosX(totalW - (i - 0.5) * 108, totalW)
		table.insert(self.tableSingle, v.point)
	end
	if SoraDFIsRA() then
		self.scrollMaterial:jumpToRight()
		self.spriteLeft:setVisible(540 < totalW)
	else
		self.scrollMaterial:jumpToLeft()
		self.spriteRight:setVisible(540 < totalW)
	end
	self:initScroll()
end
function MaterialsListView:initScroll()
	local scrollInner = self.scrollMaterial:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local scrollW = self.scrollMaterial:getContentSize().width
	_ENV = self.scrollMaterial
	self.scrollMaterial.beginX = math.max(0, offsetX - 2 * scrollW)
	local self.scrollMaterial.endX, tableShowW = offsetX + 2 * scrollW, self.scrollMaterial
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.posX < tableShowW.beginX or v.posX > tableShowW.endX then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowW.beginX <= v.posX and tableShowW.endX >= v.posX then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("materialsListSingle")
				single:addTo(self.scrollMaterial)
				single:setHandle(handler(self, self.btnMaterialCallBack))
				single:setScroll(self.scrollMaterial)
			end
			if self.type == gEquipMaterialType.MATERIAL then
				single:initMaterialSingle(v.data)
			elseif self.type == gEquipMaterialType.EQUIP then
				single:initEquipSingle(v.data)
				single:setItemPressOnBack(handler(self, self.btnEquipPressCallBack))
			end
			single:setPosition(cc.p(v.posX, 0))
			v.point = single
		end
	end
end
function MaterialsListView:scrollEventCallBack(target, event)
	self:initScroll()
	if event == ccui.ScrollviewEventType.scrollToLeft then
		self.spriteLeft:setVisible(false)
	elseif event == ccui.ScrollviewEventType.scrollToRight then
		self.spriteRight:setVisible(false)
	elseif event == ccui.ScrollviewEventType.containerMoved then
		local offsetX = self.scrollMaterial:getInnerContainer():getPositionX()
		if offsetX <= 1 and offsetX > self.scrollMaterial:getContentSize().width - self.scrollMaterial:getInnerContainerSize().width + 1 then
			self.spriteRight:setVisible(true)
			self.spriteLeft:setVisible(true)
		end
	end
end
function MaterialsListView:openItemInfo(equipData, target)
	_ENV = nil
	;(nil).name = true
	self.equipPop:initData(equipData, nil)
	local x, y = target:getPosition()
	local newPos = target:getParent():convertToWorldSpace(cc.p(x, y))
	newPos = self.centerNode:convertToNodeSpace(newPos)
	local popSize = self.equipPop:getPopSize()
	if newPos.x > SoraDFPosX(320, 0) then
		newPos.x = newPos.x - 60
	elseif newPos.x < 320 then
		newPos.x = newPos.x + 60 + popSize.width
	end
	newPos.y = newPos.y + popSize.height + 10
	self.equipPop:setPosition(newPos)
	self.equipPop:setVisible(true)
end
function MaterialsListView:closeItemInfo()
	if self.equipPop then
		self.equipPop:setVisible(false)
	end
end
function MaterialsListView:btnEquipPressCallBack(data, target, btnTarget)
	if data then
		self:openItemInfo(data, target)
	else
		self:closeItemInfo()
	end
end
function MaterialsListView:jumpCompoundView(state)
	self.openCompoundView = state
end
function MaterialsListView:btnMaterialCallBack(data, target, btnTarget)
	local equipmentltCtrl = include("equipmentltCtrl")
	if self.type == gEquipMaterialType.MATERIAL then
		if data.count > 0 then
			if self.handle then
				self.handle(data.mid, self)
			end
		elseif self.openCompoundView and equipmentltCtrl.getMaterialIDOfMerge(data.mid) then
			local panel = SoraDCreatePanel("materialsCompoundView")
			panel:initData(data.mid)
			panel:setToMid(data.mid)
			panel:show()
			self:removeFromParent()
		elseif self.jumpHandle then
			self.jumpHandle(data.mid)
		end
	elseif self.type == gEquipMaterialType.EQUIP and self.handle then
		self.handle(data, self)
	end
end
function MaterialsListView:setHandle(handle)
	self.handle = handle
end
function MaterialsListView:setJumpHandle(handle)
	self.jumpHandle = handle
end
return MaterialsListView
