function encrypt-des-cbc($inputFile, $outputFile) {
    # Convert the key and IV to bytes
    $key = [System.Text.Encoding]::UTF8.GetBytes("10000000")  # Padding with '0'
    $iv = [System.Text.Encoding]::UTF8.GetBytes("PASSWORD")    

    # Create a DES provider
    $desProvider = New-Object System.Security.Cryptography.DESCryptoServiceProvider
    $desProvider.Key = $key
    $desProvider.IV = $iv
    $desProvider.Padding = [System.Security.Cryptography.PaddingMode]::Zeros

    # Create an encryptor
    $encryptor = $desProvider.CreateEncryptor()

    # Read the content of the input file
    $inputData = Get-Content -Path "./input/$inputFile" -Raw

    # Convert the input data to bytes
    $inputBytes_UTF8 = [System.Text.Encoding]::UTF8.GetBytes($inputData)
    $inputBytes_CP932 = [System.Text.Encoding]::GetEncoding(932).GetBytes($inputData)

    # Encrypt the input data
    $encryptedBytes_UTF8 = $encryptor.TransformFinalBlock($inputBytes_UTF8, 0, $inputBytes_UTF8.Length)
    $encryptedBytes_CP932 = $encryptor.TransformFinalBlock($inputBytes_CP932, 0, $inputBytes_CP932.Length)

    # Convert the encrypted bytes to Base64 string
    $encryptedBase64_UTF8 = [Convert]::ToBase64String($encryptedBytes_UTF8)
    $encryptedBase64_CP932 = [Convert]::ToBase64String($encryptedBytes_CP932)

    # Write the encrypted data to the output file
    Add-Content -Value $encryptedBase64_CP932 -Path "./base64/CP932_$outputFile"
    Add-Content -Value $encryptedBase64_UTF8 -Path "./base64/UTF8_$outputFile"

    $encryptedBase64_CP932=$null
    $encryptedBase64_UTF8=$null
    
}

# Example usage
#encrypt-des-cbc -inputFile "test.txt" -outputFile "base64.txt"

function decrypt-des( $inputfile, $outfile){
    # Convert the key and IV to bytes
    $key = [System.Text.Encoding]::UTF8.GetBytes("10000000")  # Padding with '0'
    $iv = [System.Text.Encoding]::UTF8.GetBytes("PASSWORD")  

    # Create a DES provider
    $desProvider = New-Object System.Security.Cryptography.DESCryptoServiceProvider
    $desProvider.Key = $key
    $desProvider.IV = $iv
    $desProvider.Padding = [System.Security.Cryptography.PaddingMode]::Zeros

    # Create a decryptor
    $decryptor = $desProvider.CreateDecryptor()

    #ReadLine
    $InputData = Get-Content -Path "./base64/$inputfile"

    foreach($i in 0..($Inputdata.Length - 1)){

        # Convert the Base64-encoded ciphertext to bytes
        $ciphertextBase64 = $InputData[$i]
        $ciphertext = [Convert]::FromBase64String($ciphertextBase64)

        # Decrypt the ciphertext
        $plaintext = $decryptor.TransformFinalBlock($ciphertext, 0, $ciphertext.Length)

        # Check if $plaintext is not null before converting
        if ($null -ne $plaintext) {

            # Convert the plaintext bytes to a string using CP932 encoding
            $plaintextString = [System.Text.Encoding]::GetEncoding(932).GetString($plaintext)
            $plaintextStringUTF8 = [System.Text.Encoding]::UTF8.GetString($plaintext)

            # Output the decrypted plaintext
            Add-Content -Value $plaintextStringUTF8 -Path "./output/UTF8_$outfile"
            Add-Content -Value $plaintextString -Path "./output/CP932_$outfile"
        } else {
            #Write-Output "Decryption failed."
            return $true
        }
        $plaintextStringUTF8=$null
        $plaintextString=$null
    }
}

# Example usage
#decrypt-des -inputfile "encrypted_output.txt" -outfile "test.txt"
