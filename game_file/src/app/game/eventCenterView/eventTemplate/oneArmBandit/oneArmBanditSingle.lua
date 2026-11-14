local slotMachineRewardRead = include("slotMachineRewardRead")
local oneArmBanditSingle = class("oneArmBanditSingle", function(target)
	if target == nil then
		return display.newNode()
	end
	return target
end)
function oneArmBanditSingle:ctor()
	self:initWidget()
end
function oneArmBanditSingle:initWidget()
	local sp = display.newSprite("#icon_slotmachine_A.png")
	sp:addTo(self)
	self.sp = sp
	local frame = display.newSprite("#frame_lhj9.png")
	frame:addTo(self)
	frame:setPositionY(-50)
end
function oneArmBanditSingle:initData(index)
	self.index = index
	local imgName = slotMachineRewardRead.getSlotShowImg(index)
	self.sp:setSpriteFrame(imgName)
end
function oneArmBanditSingle:getIndex(...)
	return self.index
end
return oneArmBanditSingle
