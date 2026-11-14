local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local worldMapBottomPoint = class("worldMapBottomPoint", function(target)
	target = target or SoraDCreateBasePanel("worldMapBottomPoint")
	return target
end)
function worldMapBottomPoint:ctor()
	self.kingdomID = -1
	self.tilePoint = cc.p(-1, -1)
	self.isInCenter = nil
	SoraDGetAllChildFromWidget(self, self)
	self.NodeBgChildern = self.Node_bg:getChildren()
	self.Text_1:setString(SoraDFValueSuit("X", ":"))
	self.Text_2:setString(SoraDFValueSuit("Y", ":"))
	self.Text_3:setString(SoraDFValueSuit("K", ":"))
	self.Text_3:setVisible(false)
	self.Text_k:setVisible(false)
	self.showk = false
end
local checkShowKindomID = function(kingdomID)
	if nebulaAllStarCtrl:getIsViewer() then
		return false
	end
	return kingdomID and gKingdomClassType.normal == worldMapDefine.getKingdomMapClassByKingdomId(kingdomID)
end
function worldMapBottomPoint:updateData(tilePoint, kingdomID)
	local hasChange = false
	if self.tilePoint.x ~= tilePoint.x then
		hasChange = true
		self.Text_x:setString(tilePoint.x)
	end
	if self.tilePoint.y ~= tilePoint.y then
		hasChange = true
		self.Text_y:setString(tilePoint.y)
	end
	self.tilePoint = tilePoint
	if checkShowKindomID(kingdomID) then
		if not self.showk then
			self.Text_3:setVisible(true)
			self.Text_k:setVisible(true)
			self.showk = true
			hasChange = true
		end
		if self.kindomID ~= kingdomID then
			self.Text_k:setString(kingdomID)
			self.kingdomID = kingdomID
			hasChange = true
		end
		if hasChange then
			SoraDToCenterTarges(self.NodeBgChildern, 10)
		end
	else
		if self.showk then
			self.Text_3:setVisible(false)
			self.Text_k:setVisible(false)
			self.showk = false
			hasChange = true
		end
		if hasChange then
			SoraDToCenterTarges(self.NodeBgChildern, 20)
		end
	end
	for kClass, v in pairs(worldMapDefine.warBarrageCfg) do
		local barrageCfg = worldMapDefine.getBarrageCfg(kClass)
		if barrageCfg.showArea then
			local isInCenter = self.tilePoint.x >= barrageCfg.showArea[1] and self.tilePoint.x <= barrageCfg.showArea[2] and self.tilePoint.y >= barrageCfg.showArea[3] and self.tilePoint.y <= barrageCfg.showArea[4]
			if barrageCfg.showCondition() and self.isInCenter ~= isInCenter then
				checkShowKindomID = nil
				;(nil).msg = "MESSAGE_WAR_BARRAGE_VISIBLE"
				;(nil).isInCenter = isInCenter
				SoraDSendMessage(nil)
				self.isInCenter = isInCenter
			end
		end
	end
end
function worldMapBottomPoint:addTouchEventListener(...)
	self.Panel_touch:addTouchEventListener(...)
end
return worldMapBottomPoint
