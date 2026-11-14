local equipDesRead = include("equipDesRead")
local ArtifactShowBanner = class("artifactShowBanner", function(target)
	if target == nil then
		return SoraDCreateBasePanel("artifactShowBanner")
	end
	return target
end)
function ArtifactShowBanner:ctor()
	self.myTbl, _ENV = nil, nil
	self.Image_line = SoraDGetChildByName(self, "Image_line")
	if self.Image_line then
		self.Image_line:setVisible(false)
	end
	self.nodeSkill = SoraDGetChildByName(self, "Node_skill")
	self.btnSkill = SoraDGetChildByName(self, "Button_skill")
	self.spriteSkill = SoraDGetChildByName(self, "Sprite_skill")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelLv = SoraDGetChildByName(self, "Text_lv")
end
function ArtifactShowBanner:initData(tbl, scroll)
	self.myTbl = tbl
	self.scroll = scroll
	self:initView()
end
function ArtifactShowBanner:setLineVisible(ret)
	if self.Image_line then
		self.Image_line:setVisible(ret)
	end
end
function ArtifactShowBanner:initView(...)
	if self.myTbl and next(self.myTbl) and self.myTbl[1] then
		self.labelName:setString(equipDesRead.getArtifactName(self.myTbl[1].armsID))
		self.spriteSkill:setSpriteFrame(equipDesRead.getArtifactIcon(self.myTbl[1].armsID))
		_ENV = equipDesRead.getArtifactIcon(self.myTbl[1].armsID)
		equipDesRead.getArtifactIcon(self.myTbl[1].armsID).lv = self.myTbl[1].level
		self.labelLv:setString(i18n("common_text_100", equipDesRead.getArtifactIcon(self.myTbl[1].armsID)))
	end
end
return ArtifactShowBanner
