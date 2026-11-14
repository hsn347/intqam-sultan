local castleSkinRead = include("castleSkinRead")
local dressltCtrl = include("dressltCtrl")
local castleSkinConfigRead = include("castleSkinConfigRead")
local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildNameBox = class("worldMapBuildNameBox", worldMapBuildComNew)
function worldMapBuildNameBox:ctor(...)
	worldMapBuildNameBox.super.ctor(self, ...)
end
function worldMapBuildNameBox:_initData(...)
	self.playerID = 0
end
function worldMapBuildNameBox:_initUI(...)
	self.image_crown = self.target_.image_crown
	self.image_name = self.target_.image_name
	self.image_name_bg = self.target_.image_name_bg
	self.image_nameBgSkin = self.target_.image_nameBgSkin
	self.text_Name = self.target_.text_Name
end
function worldMapBuildNameBox:updateData(data)
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.nameBox then
		if data.nameBox ~= 0 then
			local nameBgSkin = castleSkinRead.getNameFloor(data.nameBox)
			local subType = dressltCtrl.getSubType(data.nameBox)
			print("nameBgSkin,subType=====", nameBgSkin, subType)
			if nameBgSkin and 0 < string.len(nameBgSkin) then
				self.image_crown:setVisible(false)
				self.image_name:setVisible(false)
				self.image_name_bg:setVisible(false)
				self.image_nameBgSkin:setVisible(true)
				self.image_nameBgSkin:setSpriteFrame(nameBgSkin)
				self.image_nameBgSkin:removeAllChildren()
				self.text_Name:setPositionY(self.centerPoint.y - 90)
				local nameBoxCfg = castleSkinConfigRead.getNameBoxCfg(subType)
				if nameBoxCfg then
					print("offSetY=======", nameBoxCfg.offSetY)
					self.text_Name:setPositionY(self.centerPoint.y - 90 + nameBoxCfg.offSetY)
					if nameBoxCfg.color then
						self.text_Name:setColor(nameBoxCfg.color)
					end
				end
				if subType == 417 then
					local et_bgsk = display.newSprite("#dh_ltmp_01.png")
					SoraDMixtureGLONE(et_bgsk)
					et_bgsk:setPosition(self.image_nameBgSkin:getContentSize().width / 2, self.image_nameBgSkin:getContentSize().height / 2)
					et_bgsk:addTo(self.image_nameBgSkin)
					local frames = display.newFrames("dh_ltmp_%.2d.png", 1, 24)
					local animation = display.newAnimation(frames, 2 / #frames)
					et_bgsk:playAnimationForever(animation)
				end
				if subType == 425 then
					local et_bgsk = display.newSprite("#dh_yqzcltzb_mp_01.png")
					SoraDMixtureGLONE(et_bgsk)
					et_bgsk:setPosition(self.image_nameBgSkin:getContentSize().width / 2, self.image_nameBgSkin:getContentSize().height / 2)
					et_bgsk:addTo(self.image_nameBgSkin)
					local frames = display.newFrames("dh_yqzcltzb_mp_%.2d.png", 1, 24)
					local animation = display.newAnimation(frames, 2 / #frames)
					et_bgsk:playAnimationForever(animation)
				end
			end
		else
			self.image_name_bg:setVisible(SoraDGetCastleWarLv() >= 5)
			self.image_name:setVisible(true)
			self.image_nameBgSkin:setVisible(false)
			local selfPlayerID = SoraDGetPlayerID()
			if self.playerID == selfPlayerID then
				self.image_crown:setVisible(true)
				self.text_Name:setPositionY(self.centerPoint.y - 90)
			end
		end
	end
end
return worldMapBuildNameBox
