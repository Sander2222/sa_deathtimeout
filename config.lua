Config = {}

Config.Timeout = 30 -- in sec

Config.RemoveTimeout = 'removetimeout'
Config.RemoveTimeoutRadius = 'removeradius'
Config.Groups = {'admin', 'mod'}

Config.Locals = {
    ['TargetRemoveTimeout'] = 'Your timeout has removed',
    ['PlayerRemovedTimeout'] = 'You removed the player %s the timeout',
    ['RemovedSelfTimeout'] = 'You removed the timeout yourself',
    ['NoPlayerWithTimeOut'] = 'There is no player who has a timeout with this ID',
    ['NoRights'] = 'You have no permission to do that',
    ['EnterNumber'] = 'You must specify a radius as a number',
    ['ContactSupport'] = 'Please contact our support',
    ['NoPlayers'] = 'There are no players nearby',
    ['ProbablyModder'] = 'This ID %s is probably a modder: %s'
}