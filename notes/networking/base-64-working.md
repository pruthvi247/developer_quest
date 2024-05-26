## How Base64 works

Fundamentally, Base64 is used to encode binary data as printable text. This allows you to transport binary over protocols or mediums that cannot handle binary data formats and require simple text.

Base64 uses 6-bit characters grouped into 24-bit sequences. For example, consider the sentence **Hi\n**, where the **\n** represents a newline. The first step in the encoding process is to obtain the binary representation of each ASCII character. This can be done by looking up the values in an [ASCII-to-binary conversion table](https://www.rapidtables.com/code/text/ascii-table.html).

![[Pasted image 20231005101437.png]]
ASCII uses 8 bits to represent individual characters, but Base64 uses 6 bits. Therefore, the binary needs to be broken up into 6-bit chunks.
![[Pasted image 20231005101455.png]]
Finally, these 6-bit values can be converted into the appropriate printable character by using a [Base64 table](https://en.wikipedia.org/wiki/Base64#Base64_table_from_RFC_4648).
![[Pasted image 20231005101513.png]]
Since Base64 uses 24-bit sequences, _padding_ is needed when the original binary cannot be divided into a 24-bit sequence. You have probably seen this type of padding before represented by printed equal signs (**=**). For example, **Hi** without a newline is represented by only two 8-bit ASCII characters (for a total of 16 bits). Padding is removed by the Base64 encoding schema when data is decoded.
![[Pasted image 20231005101528.png]]
## Encode and decode Base64 at the command line

Now that you understand how Base64 encoding works, you can work with it at the command line. You can use the `base64` command-line utility to encode and decode files or standard input. For example, to encode the previous example:

```shell
$ echo Hi | base64
SGkK
```
![[Pasted image 20240312132149.png]]
- Encoding  
    Encoding converts data into a different format using a scheme that can be easily reversed. Examples include Base64 encoding, which encodes binary data into ASCII characters, making it easier to transmit data over media that are designed to deal with textual data.  
      
    Encoding is not meant for securing data. The encoded data can be easily decoded using the same scheme without the need for a key.  
    
- Encryption  
    Encryption involves complex algorithms that use keys for transforming data. Encryption can be symmetric (using the same key for encryption and decryption) or asymmetric (using a public key for encryption and a private key for decryption).  
      
    Encryption is designed to protect data confidentiality by transforming readable data (plaintext) into an unreadable format (ciphertext) using an algorithm and a secret key. Only those with the correct key can decrypt and access the original data.  
    
- Tokenization  
    Tokenization is the process of substituting sensitive data with non-sensitive placeholders called tokens. The mapping between the original data and the token is stored securely in a token vault. These tokens can be used in various systems and processes without exposing the original data, reducing the risk of data breaches.
    
      
    Tokenization is often used for protecting credit card information, personal identification numbers, and other sensitive data. Tokenization is highly secure, as the tokens do not contain any part of the original data and thus cannot be reverse-engineered to reveal the original data. It is particularly useful for compliance with regulations like PCI DSS.
