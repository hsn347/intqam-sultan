local remainsWarRead = include("remainsWarRead")
local remainsWarltCtrl = include("remainsWarltCtrl")
local MAX_ANIMATION = 1.0
local DELAY_ACTION = 1.0
local SHOW_DAN = 0.5
local remainsWarScoreView = class("remainsWarScoreView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("remainsWarScoreView")
	end
	return target
end)
function remainsWarScoreView:ctor()
	self:setBackGround(229.5)
	self.nodeSuc = SoraDGetChildByName(self, "Node_suc")
	self.nodeFail = SoraDGetChildByName(self, "Node_fail")
	self.nodeScore = SoraDGetChildByName(self, "Top_Node_score")
	self.nodeTextScore = SoraDGetChildByName(self, "Node_Text_score")
	self.nodeFlag = SoraDGetChildByName(self, "Top_Node_flag")
	self.nodeParticle1 = SoraDGetChildByName(self, "Top_particle_bg")
	self.nodeParticle1:setVisible(false)
	self.nodeParticle2 = SoraDGetChildByName(self, "Top_particle_fg")
	self.nodeParticle2:setVisible(false)
	self.txtScore = SoraDGetChildByName(self, "Text_score")
	SoraDCreateScoreLabel(self.txtScore)
	self.txtScore:setVisible(false)
	self.txtScore:setFormatHandle(function(numText)
		local formatted = string.formatnumberthousands(numText)
		if 0 <= numText then
			return "+" .. formatted
		end
		return formatted
	end)
	self.Panel_bar = SoraDGetChildByName(self, "Panel_bar")
	self.et_node_exp_full = SoraDGetChildByName(self, "et_node_exp_full")
	self.nodeProBar = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_score")
	self.nodeProBar:setActionDelay(0.5)
	self.nodeProBar:setNoRefreshLabel(true)
	self.nodeProBar:setHandle(function(data)
		local curPro = 100 * data.actionValue / data.maxValue
		self.Panel_bar:setContentSize(cc.size(568 * curPro / 100, 92))
	end)
	self.txtProgress = SoraDGetChildByName(self, "Text_progress")
	self.txtProgress:setVisible(false)
	self.spScoreTitle = SoraDGetChildByName(self, "Sprite_score_title")
	if not IsArClient then
		self.txtScoreTitle = SoraDChangeDanToText(self.spScoreTitle)
	end
	self.tableSingleData, _ENV, self.spDanBg = SoraDGetChildByName(self, "Sprite_dan_bg"), SoraDGetChildByName(self, "Sprite_dan_bg"), SoraDGetChildByName(self, "Sprite_dan_bg")
	self.frame_rank = SoraDGetChildByName(self, "Size_Panel_touch")
	self.imgBg = SoraDGetChildByName(self, "Top_Image_bg")
	local imageDanFullPath = "bg_mailinfo_attackfailure"
	if not _G.SoraDHasActivieyBg(imageDanFullPath) then
		self.imgBg:setVisible(false)
	else
		self.imgBg:setVisible(true)
		local scale = self.frame_rank:getContentSize().height / 210
		self.imgBg:setScale(scale * 1.1)
	end
	self:initParticleEffect()
end
function remainsWarScoreView:initParticleEffect()
	for i = 1, 2 do
		local particle = SoraDGetChildByName(self, "Particle_light_" .. i)
		if particle and particle.setAutoCull then
			particle:setAutoCull(false)
		end
	end
	for i = 1, 4 do
		local particle = SoraDGetChildByName(self, "Particle_bottom_" .. i)
		if particle and particle.setAutoCull then
			particle:setAutoCull(false)
		end
	end
end
function remainsWarScoreView:initData(data)
