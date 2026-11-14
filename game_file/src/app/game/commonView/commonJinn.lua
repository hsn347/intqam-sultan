local gametop = gModuleMgr.getObject("gametop")
local magicLampRead = include("magicLampRead")
local commonJinn = class("commonJinn", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonJinn")
	end
	return target
end)
function commonJinn:ctor()
	self.spriteHead = SoraDGetChildByName(self, "Sprite_head")
	self.spriteBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.spriteBg:setSpriteFrame("frame_item_base_04.png")
	self.textLv = SoraDGetChildByName(self, "Text_lv")
end
function commonJinn:initData(jinnID, starLv, lv)
	local jinnCfg = magicLampRead.getJinnCfg(jinnID, starLv)
	self.spriteHead:setSpriteFrame(jinnCfg.battleLogIcon)
	self.textLv:setString(lv)
end
function commonJinn:btnAddCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
return commonJinn
