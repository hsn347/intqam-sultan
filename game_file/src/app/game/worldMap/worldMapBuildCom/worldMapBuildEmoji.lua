local worldMapBuildEmoji = class("worldMapBuildEmoji", function(target)
	return target
end)
local GROU_ID = worldMapDefine.GROU_ID
function worldMapBuildEmoji:updateEmojiByData(data)
	if data.emoji then
		self:updateEmoji(data.emoji)
	end
	if data.ownerUid then
		self.ownerUid = data.ownerUid
	end
end
function worldMapBuildEmoji:canHasEmojiOperator(playerID)
	if not playerID then
		local gametop = gModuleMgr.getObject("gametop")
		playerID = gametop.playertop_:getPlayerID() or 0
	end
	if self.ownerUid and self.ownerUid == playerID then
		return true
	end
end
function worldMapBuildEmoji:resetBuildEmoji()
	self.emojiID = nil
	self.ownerUid = nil
	self:removeEmoji()
end
function worldMapBuildEmoji:updateEmoji(emojiID)
	if emojiID then
		if 0 < emojiID then
			self.emojiID = emojiID
			self:showEmoji(emojiID)
		elseif emojiID == 0 then
			self.emojiID = nil
			self:hideEmoji()
		end
	end
end
function worldMapBuildEmoji:isHasEmoji()
	return self.emojiID and self.emojiID > 0
end
function worldMapBuildEmoji:showEmoji(emojiID)
	self:addEmoji(emojiID)
end
function worldMapBuildEmoji:hideEmoji()
	if self.worldMapEmoji then
		self.worldMapEmoji:stopAllActions()
		_UPVALUE2_ = self.worldMapEmoji
		self.worldMapEmoji[1] = cca.callFunc(function()
			self.worldMapEmoji:hideAction()
		end)
		self.worldMapEmoji[2] = cca.delay(1)
		self.worldMapEmoji[3] = cca.callFunc(function()
			self.worldMapEmoji:removeFromParent()
			self.worldMapEmoji = nil
		end)
		self.worldMapEmoji[4] = cca.callFunc(function()
			self.worldMapEmoji:removeFromParent()
			self.worldMapEmoji = nil
		end)
		local seq = cca.seq(self.worldMapEmoji)
		self.worldMapEmoji:runAction(seq)
	end
end
function worldMapBuildEmoji:addEmoji(emojiID, pos)
	if not self.worldMapEmoji then
		self.worldMapEmoji = include("worldMapEmoji").new()
		if pos then
			self.worldMapEmoji:setPosition(pos)
		else
			self.worldMapEmoji:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 100))
		end
		self.worldMapEmoji:addTo(self, 9)
		self.worldMapEmoji:setGroupID(GROU_ID.group_emoji)
		self.worldMapEmoji:setGroupAuto(true)
		self.worldMapEmoji:setEmoji(emojiID)
		self.worldMapEmoji:showAction()
	else
		self.worldMapEmoji:setEmoji(emojiID)
		self.worldMapEmoji:showAction()
	end
end
function worldMapBuildEmoji:removeEmoji()
	if self.worldMapEmoji then
		self.worldMapEmoji:removeFromParent()
		self.worldMapEmoji = nil
	end
end
return worldMapBuildEmoji
