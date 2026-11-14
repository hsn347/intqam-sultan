local _ENV, legendTeamDef
legendTeamDef.TEAM_MEMBER_MAX = 30
_ENV, legendTeamDef.APPLY_TEAM_MEMBER_SHOW_MAX = nil, 5
;(nil).CHANGE_LEADER = 1
;(nil).DISMISS = 2
;(nil).VIEW_APPROLY = 4
local (nil).CHANGE_FLAG, teamManageType = 5, nil
_ENV, legendTeamDef.TeamManageType = nil, teamManageType
;(nil).CHANGE_LEADER = 1
;(nil).DISMISS = 2
;(nil).VIEW_APPROLY = 4
;(nil).CHANGE_FLAG = 5
local (nil).COMMANDERS, teamManageType_legend = 6, nil
legendTeamDef.TeamManageType_legend = teamManageType_legend
legendTeamDef.APPLY_TEAM_COMMANDERS_MAX = 2
return legendTeamDef
