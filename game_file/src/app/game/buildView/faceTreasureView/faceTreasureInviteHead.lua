local FaceTreasureInviteHead = class("faceTreasureInviteHead", function(target)
	if target == nil then
		return SoraDCreateBasePanel("faceTreasureInviteHead")
	end
	return target
end)
function FaceTreasureInviteHead:ctor()
	self.myData, _ENV, self.fbHeadFileFlag = nil, nil, "FaceBookAllAvatar_"
	self.imgPlayer = SoraDGetChildByName(self, "Image_player")
	self.txtPlayer = SoraDGetChildByName(self, "Text_player")
	self.checkBox = SoraDGetChildByName(self, "CheckBox_check")
	function self.imgPlayer.isAlive(...)
		return true
	end
	self.checkBox:addEventListener(handler(self, self.checkBoxClick))
end
function FaceTreasureInviteHead:initData(data)
	self.myData = data
	self:initView()
end
function FaceTreasureInviteHead:initView(...)
	self.txtPlayer:setString(self.myData.fName or "")
	if self.myData.fHead then
		local ocx = self.imgPlayer
		SoraDGetHTTPPic(self.myData.fHead, self.fbHeadFileFlag .. self.myData.fID, ocx, self.imgPlayer:getContentSize())
	end
end
function FaceTreasureInviteHead:checkBoxClick(button, type)
	local clickCallBack = function()
		if self.clickHandl then
			self.clickHandl()
		end
	end
	if type == ccui.CheckBoxEventType.selected then
		clickCallBack()
	elseif type == ccui.CheckBoxEventType.unselected then
		clickCallBack()
	end
end
function FaceTreasureInviteHead:setMeCheck(bool)
	self.checkBox:setSelected(bool)
end
function FaceTreasureInviteHead:getFID(...)
	return self.myData.fID or ""
end
function FaceTreasureInviteHead:returnName(...)
	return self.myData.fName or ""
end
function FaceTreasureInviteHead:returnIsCheck(...)
	return self.checkBox:isSelected()
end
function FaceTreasureInviteHead:setFatherClickHandl(handl)
	self.clickHandl = handl
end
return FaceTreasureInviteHead
