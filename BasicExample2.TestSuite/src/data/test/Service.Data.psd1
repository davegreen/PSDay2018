@{
    Services = @(
        @{ 
            Name   = 'BDESVC' 
            Status = 'Running'
        },
        @{ 
            Name   = 'XblGameSave' 
            Status = 'Running'
        }
    )

    Process = "ApplicationFrameHost"
}