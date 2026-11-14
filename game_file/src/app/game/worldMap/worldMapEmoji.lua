local emojiSealList = require("app." .. LocalTblPath .. ".config_client.emojseallist")
local worldMapEmoji = class("worldMapEmoji", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapEmoji")
	end
	return target
end)
function worldMapEmoji:ctor()
	self.emoji = SoraDGetChildByName(self, "emoji")
end
function worldMapEmoji:setEmoji(emojiID)
	local emojiImg = "emoj_seal_1.png"
	for k, v in ipairs(emojiSealList) do
		if v.FaceId == emojiID then
			emojiImg = v.Image
			if not SoraDFIsRA() and v.imgEn and v.imgEn ~= "" then
				emojiImg = v.imgEn
			end
			break
		end
	end
	self.emoji:setSpriteFrame(emojiImg)
end
function worldMapEmoji:showAction(moveLine)
	self:stopAllActions()
	self:setScale(0)
	local scale = 1.0
	if moveLine then
		scale = 0.7
	end
	self:runAction(cc.EaseElasticOut:create(cca.scaleTo(1.0, scale)))
end
function worldMapEmoji:hideAction()
	self:runAction(cc.EaseElasticIn:create(cca.scaleTo(1.0, 0)))
end
return worldMapEmoji
