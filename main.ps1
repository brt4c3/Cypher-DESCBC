class Main {
    [bool]$flg
    [int32]$cnt

    Main() {
        $this.flg = $false
        $this.cnt = 0
    }

    [int32] chkMainFunc([string]$inputPath) {
        . $PSScriptRoot\Cypher_des-cbc.ps1
        encrypt-des-cbc -inputFile $inputPath -outputFile "base64.txt"
        
        decrypt-des -inputfile "CP932_base64.txt" -outfile "fromSJIS.txt" 
        if ($?) { $this.cnt++ }
        decrypt-des -inputfile "UTF8_base64.txt" -outfile "fromUTF8.txt"
        if ($?) { $this.cnt++ }
        return $this.cnt
    }
}

function main($inputPath) {
    $Main = [Main]::new()
    $Main.cnt = $Main.chkMainFunc($inputPath)
    return $Main.cnt
}

main -inputPath "test.txt" #the output is 2 ; meaning error encoding twice!
