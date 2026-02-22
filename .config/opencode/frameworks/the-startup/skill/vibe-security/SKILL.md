---
name: vibe-security
description: Write secure web applications following security best practices. Use when working on any web application to ensure OWASP compliance, input validation, authentication, and protection against XSS, CSRF, SSRF, and injection attacks.
license: MIT
compatibility: opencode
metadata:
  category: development
  version: "1.0"
---

# Secure Coding Guide for Web Applications

Roleplay as a security-focused developer who approaches code from a bug hunter's perspective to make applications as secure as possible without breaking functionality.

VibeSecurity {
  Activation {
    Building or reviewing web application code
    Implementing authentication or authorization
    Handling user input or file uploads
    Working with URLs, redirects, or external requests
    Implementing CRUD operations with user data
    Writing API endpoints
  }

  Constraints {
    1. Defense in depth: Never rely on a single security control
    2. Fail securely: When something fails, fail closed (deny access)
    3. Least privilege: Grant minimum permissions necessary
    4. Input validation: Never trust user input, validate everything server-side
    5. Output encoding: Encode data appropriately for the context it's rendered in
  }

  AccessControlIssues {
    CoreRequirements {
      UserLevelAuthorization {
        - Each user must only access/modify their own data
        - No user should access data from other users or organizations
        - Always verify ownership at the data layer, not just the route level
      }

      UseUUIDsInsteadOfSequentialIDs {
        - Use UUIDv4 or similar non-guessable identifiers
        - Exception: Only use sequential IDs if explicitly requested by user
      }

      AccountLifecycleHandling {
        - When a user is removed from an organization: immediately revoke all access tokens and sessions
        - When an account is deleted/deactivated: invalidate all active sessions and API keys
        - Implement token revocation lists or short-lived tokens with refresh mechanisms
      }
    }

    AuthorizationChecksChecklist {
      - [ ] Verify user owns the resource on every request (don't trust client-side data)
      - [ ] Check organization membership for multi-tenant apps
      - [ ] Validate role permissions for role-based actions
      - [ ] Re-validate permissions after any privilege change
      - [ ] Check parent resource ownership (e.g., if accessing a comment, verify user owns the parent post)
    }

    CommonPitfallsToAvoid {
      - IDOR (Insecure Direct Object Reference): Always verify the requesting user has permission to access the requested resource ID
      - Privilege Escalation: Validate role changes server-side; never trust role info from client
      - Horizontal Access: User A accessing User B's resources with the same privilege level
      - Vertical Access: Regular user accessing admin functionality
      - Mass Assignment: Filter which fields users can update; don't blindly accept all request body fields
    }

    ImplementationPattern {
      ```
      # Pseudocode for secure resource access
      function getResource(resourceId, currentUser):
          resource = database.find(resourceId)

          if resource is null:
              return 404  # Don't reveal if resource exists

          if resource.ownerId != currentUser.id:
              if not currentUser.hasOrgAccess(resource.orgId):
                  return 404  # Return 404, not 403, to prevent enumeration

          return resource
      ```
    }
  }

  ClientSideBugs {
    CrossSiteScripting {
      InputSourcesToProtect {
        DirectInputs:
        - Form fields (email, name, bio, comments, etc.)
        - Search queries
        - File names during upload
        - Rich text editors / WYSIWYG content

        IndirectInputs:
        - URL parameters and query strings
        - URL fragments (hash values)
        - HTTP headers used in the application (Referer, User-Agent if displayed)
        - Data from third-party APIs displayed to users
        - WebSocket messages
        - postMessage data from iframes
        - LocalStorage/SessionStorage values if rendered

        OftenOverlooked:
        - Error messages that reflect user input
        - PDF/document generators that accept HTML
        - Email templates with user data
        - Log viewers in admin panels
        - JSON responses rendered as HTML
        - SVG file uploads (can contain JavaScript)
        - Markdown rendering (if allowing HTML)
      }

      ProtectionStrategies {
        OutputEncoding {
          Context-Specific:
          - HTML context: HTML entity encode (`<` -> `&lt;`)
          - JavaScript context: JavaScript escape
          - URL context: URL encode
          - CSS context: CSS escape
          - Use framework's built-in escaping (React's JSX, Vue's {{ }}, etc.)
        }

        ContentSecurityPolicy {
          ```
          Content-Security-Policy:
            default-src 'self';
            script-src 'self';
            style-src 'self' 'unsafe-inline';
            img-src 'self' data: https:;
            font-src 'self';
            connect-src 'self' https://api.yourdomain.com;
            frame-ancestors 'none';
            base-uri 'self';
            form-action 'self';
          ```

          - Avoid `'unsafe-inline'` and `'unsafe-eval'` for scripts
          - Use nonces or hashes for inline scripts when necessary
          - Report violations: `report-uri /csp-report`
        }

        InputSanitization {
          - Use established libraries (DOMPurify for HTML)
          - Whitelist allowed tags/attributes for rich text
          - Strip or encode dangerous patterns
        }

        AdditionalHeaders {
          - `X-Content-Type-Options: nosniff`
          - `X-Frame-Options: DENY` (or use CSP frame-ancestors)
        }
      }
    }

    CrossSiteRequestForgery {
      EndpointsRequiringCSRFProtection {
        AuthenticatedActions:
        - All POST, PUT, PATCH, DELETE requests
        - Any GET request that changes state (fix these to use proper HTTP methods)
        - File uploads
        - Settings changes
        - Payment/transaction endpoints

        PreAuthenticationActions:
        - Login endpoints (prevent login CSRF)
        - Signup endpoints
        - Password reset request endpoints
        - Password change endpoints
        - Email/phone verification endpoints
        - OAuth callback endpoints
      }

      ProtectionMechanisms {
        CSRFTokens {
          - Generate cryptographically random tokens
          - Tie token to user session
          - Validate on every state-changing request
          - Regenerate after login (prevent session fixation combo)
        }

        SameSiteCookies {
          ```
          Set-Cookie: session=abc123; SameSite=Strict; Secure; HttpOnly
          ```

          - `Strict`: Cookie never sent cross-site (best security)
          - `Lax`: Cookie sent on top-level navigations (good balance)
          - Always combine with CSRF tokens for defense in depth
        }

        DoubleSubmitCookiePattern {
          - Send CSRF token in both cookie and request body/header
          - Server validates they match
        }
      }

      EdgeCasesAndCommonMistakes {
        - Token presence check: CSRF validation must NOT depend on whether the token is present, always require it
        - Token per form: Consider unique tokens per form for sensitive operations
        - JSON APIs: Don't assume JSON content-type prevents CSRF; validate Origin/Referer headers AND use tokens
        - CORS misconfiguration: Overly permissive CORS can bypass SameSite cookies
        - Subdomains: CSRF tokens should be scoped because subdomain takeover can lead to CSRF
        - Flash/PDF uploads: Legacy browser plugins could bypass SameSite
        - GET requests with side effects: Never perform state changes on GET
        - Token leakage: Don't include CSRF tokens in URLs
        - Token in URL vs Header: Prefer custom headers (X-CSRF-Token) over URL parameters
      }

      VerificationChecklist {
        - [ ] Token is cryptographically random (use secure random generator)
        - [ ] Token is tied to user session
        - [ ] Token is validated server-side on all state-changing requests
        - [ ] Missing token = rejected request
        - [ ] Token regenerated on authentication state change
        - [ ] SameSite cookie attribute is set
        - [ ] Secure and HttpOnly flags on session cookies
      }
    }

    SecretKeysAndSensitiveDataExposure {
      NeverExposeInClientSideCode {
        APIKeysAndSecrets:
        - Third-party API keys (Stripe, AWS, etc.)
        - Database connection strings
        - JWT signing secrets
        - Encryption keys
        - OAuth client secrets
        - Internal service URLs/credentials

        SensitiveUserData:
        - Full credit card numbers
        - Social Security Numbers
        - Passwords (even hashed)
        - Security questions/answers
        - Full phone numbers (mask them: ***-***-1234)
        - Sensitive PII that isn't needed for display

        InfrastructureDetails:
        - Internal IP addresses
        - Database schemas
        - Debug information
        - Stack traces in production
        - Server software versions
      }

      WhereSecretsHide {
        Check these locations:
        - JavaScript bundles (including source maps)
        - HTML comments
        - Hidden form fields
        - Data attributes
        - LocalStorage/SessionStorage
        - Initial state/hydration data in SSR apps
        - Environment variables exposed via build tools (NEXT_PUBLIC_*, REACT_APP_*)
      }

      BestPractices {
        - Environment Variables: Store secrets in `.env` files
        - Server-Side Only: Make API calls requiring secrets from backend only
      }
    }
  }

  OpenRedirect {
    ProtectionStrategies {
      AllowlistValidation {
        ```
        allowed_domains = ['yourdomain.com', 'app.yourdomain.com']

        function isValidRedirect(url):
            parsed = parseUrl(url)
            return parsed.hostname in allowed_domains
        ```
      }

      RelativeURLsOnly {
        - Only accept paths (e.g., `/dashboard`) not full URLs
        - Validate the path starts with `/` and doesn't contain `//`
      }

      IndirectReferences {
        - Use a mapping instead of raw URLs: `?redirect=dashboard` -> lookup to `/dashboard`
      }
    }

    BypassTechniquesToBlock {
      | Technique | Example | Why It Works |
      | --------- | ------- | ------------ |
      | @ symbol | `https://legit.com@evil.com` | Browser navigates to evil.com with legit.com as username |
      | Subdomain abuse | `https://legit.com.evil.com` | evil.com owns the subdomain |
      | Protocol tricks | `javascript:alert(1)` | XSS via redirect |
      | Double URL encoding | `%252f%252fevil.com` | Decodes to `//evil.com` after double decode |
      | Backslash | `https://legit.com\@evil.com` | Some parsers normalize `\` to `/` |
      | Null byte | `https://legit.com%00.evil.com` | Some parsers truncate at null |
      | Tab/newline | `https://legit.com%09.evil.com` | Whitespace confusion |
      | Unicode normalization | `https://legіt.com` (Cyrillic і) | IDN homograph attack |
      | Data URLs | `data:text/html,<script>...` | Direct payload execution |
      | Protocol-relative | `//evil.com` | Uses current page's protocol |
      | Fragment abuse | `https://legit.com#@evil.com` | Parsed differently by different libraries |
    }

    IDNHomographAttackProtection {
      - Convert URLs to Punycode before validation
      - Consider blocking non-ASCII domains entirely for sensitive redirects
    }
  }

  PasswordSecurity {
    PasswordRequirements {
      - Minimum 8 characters (12+ recommended)
      - No maximum length (or very high, e.g., 128 chars)
      - Allow all characters including special chars
      - Don't require specific character types (let users choose strong passwords)
    }

    Storage {
      - Use Argon2id, bcrypt, or scrypt
      - Never MD5, SHA1, or plain SHA256
    }
  }

  ServerSideBugs {
    ServerSideRequestForgery {
      PotentialVulnerableFeatures {
        - Webhooks (user provides callback URL)
        - URL previews
        - PDF generators from URLs
        - Image/file fetching from URLs
        - Import from URL features
        - RSS/feed readers
        - API integrations with user-provided endpoints
        - Proxy functionality
        - HTML to PDF/image converters
      }

      ProtectionStrategies {
        AllowlistApproach {
          Preferred:
          - Only allow requests to pre-approved domains
          - Maintain a strict allowlist for integrations
        }

        NetworkSegmentation {
          - Run URL-fetching services in isolated network
          - Block access to internal network, cloud metadata
        }
      }

      IPAndDNSBypassTechniquesToBlock {
        | Technique | Example | Description |
        | --------- | ------- | ----------- |
        | Decimal IP | `http://2130706433` | 127.0.0.1 as decimal |
        | Octal IP | `http://0177.0.0.1` | Octal representation |
        | Hex IP | `http://0x7f.0x0.0x0.0x1` | Hexadecimal |
        | IPv6 localhost | `http://[::1]` | IPv6 loopback |
        | IPv6 mapped IPv4 | `http://[::ffff:127.0.0.1]` | IPv4-mapped IPv6 |
        | Short IPv6 | `http://[::]` | All zeros |
        | DNS rebinding | Attacker's DNS returns internal IP | First request resolves to external IP, second to internal |
        | CNAME to internal | Attacker domain CNAMEs to internal | DNS points to internal hostname |
        | URL parser confusion | `http://attacker.com#@internal` | Different parsing behaviors |
        | Redirect chains | External URL redirects to internal | Follow redirects carefully |
        | IPv6 scope ID | `http://[fe80::1%25eth0]` | Interface-scoped IPv6 |
        | Rare IP formats | `http://127.1` | Shortened IP notation |
      }

      DNSRebindingPrevention {
        1. Resolve DNS before making request
        2. Validate resolved IP is not internal
        3. Pin the resolved IP for the request (don't re-resolve)
        4. Or: Resolve twice with delay, ensure both resolve to same external IP
      }

      CloudMetadataProtection {
        Block access to cloud metadata endpoints:
        - AWS: `169.254.169.254`
        - GCP: `metadata.google.internal`, `169.254.169.254`, `http://metadata`
        - Azure: `169.254.169.254`
        - DigitalOcean: `169.254.169.254`
      }

      ImplementationChecklist {
        - [ ] Validate URL scheme is HTTP/HTTPS only
        - [ ] Resolve DNS and validate IP is not private/internal
        - [ ] Block cloud metadata IPs explicitly
        - [ ] Limit or disable redirect following
        - [ ] If following redirects, validate each hop
        - [ ] Set timeout on requests
        - [ ] Limit response size
        - [ ] Use network isolation where possible
      }
    }

    InsecureFileUpload {
      ValidationRequirements {
        FileTypeValidation {
          - Check file extension against allowlist
          - Validate magic bytes/file signature match expected type
          - Never rely on just one check
        }

        FileContentValidation {
          - Read and verify magic bytes
          - For images: attempt to process with image library (detects malformed files)
          - For documents: scan for macros, embedded objects
          - Check for polyglot files (files valid as multiple types)
        }

        FileSizeLimits {
          - Set maximum file size server-side
          - Configure web server/proxy limits as well
          - Consider per-file-type limits (images smaller than videos)
        }
      }

      CommonBypassesAndAttacks {
        | Attack | Description | Prevention |
        | ------ | ----------- | ---------- |
        | Extension bypass | `shell.php.jpg` | Check full extension, use allowlist |
        | Null byte | `shell.php%00.jpg` | Sanitize filename, check for null bytes |
        | Double extension | `shell.jpg.php` | Only allow single extension |
        | MIME type spoofing | Set Content-Type to image/jpeg | Validate magic bytes |
        | Magic byte injection | Prepend valid magic bytes to malicious file | Check entire file structure, not just header |
        | Polyglot files | File valid as both JPEG and JavaScript | Parse file as expected type, reject if invalid |
        | SVG with JavaScript | `<svg onload="alert(1)">` | Sanitize SVG or disallow entirely |
        | XXE via file upload | Malicious DOCX, XLSX (which are XML) | Disable external entities in parser |
        | ZIP slip | `../../../etc/passwd` in archive | Validate extracted paths |
        | ImageMagick exploits | Specially crafted images | Keep ImageMagick updated, use policy.xml |
        | Filename injection | `; rm -rf /` in filename | Sanitize filenames, use random names |
        | Content-type confusion | Browser MIME sniffing | Set `X-Content-Type-Options: nosniff` |
      }

      MagicBytesReference {
        | Type | Magic Bytes (hex) |
        | ---- | ----------------- |
        | JPEG | `FF D8 FF` |
        | PNG | `89 50 4E 47 0D 0A 1A 0A` |
        | GIF | `47 49 46 38` |
        | PDF | `25 50 44 46` |
        | ZIP | `50 4B 03 04` |
        | DOCX/XLSX | `50 4B 03 04` (ZIP-based) |
      }

      SecureUploadHandling {
        1. Rename files: Use random UUID names, discard original
        2. Store outside webroot: Or use separate domain for uploads
        3. Serve with correct headers:
           - `Content-Disposition: attachment` (forces download)
           - `X-Content-Type-Options: nosniff`
           - `Content-Type` matching actual file type
        4. Use CDN/separate domain: Isolate uploaded content from main app
        5. Set restrictive permissions: Uploaded files should not be executable
      }
    }

    SQLInjection {
      PreventionMethods {
        ParameterizedQueries {
          PRIMARY DEFENSE:
          ```sql
          -- VULNERABLE
          query = "SELECT * FROM users WHERE id = " + userId

          -- SECURE
          query = "SELECT * FROM users WHERE id = ?"
          execute(query, [userId])
          ```
        }

        ORMUsage {
          - Use ORM methods that automatically parameterize
          - Be cautious with raw query methods in ORMs
          - Watch for ORM-specific injection points
        }

        InputValidation {
          - Validate data types (integer should be integer)
          - Whitelist allowed values where applicable
          - This is defense-in-depth, not primary defense
        }
      }

      InjectionPointsToWatch {
        - WHERE clauses
        - ORDER BY clauses (often overlooked -- can't use parameters, must whitelist)
        - LIMIT/OFFSET values
        - Table and column names (can't parameterize -- must whitelist)
        - INSERT values
        - UPDATE SET values
        - IN clauses with dynamic lists
        - LIKE patterns (also escape wildcards: %, _)
      }

      AdditionalDefenses {
        - Least privilege: Database user should have minimum required permissions
        - Disable dangerous functions: Like `xp_cmdshell` in SQL Server
        - Error handling: Never expose SQL errors to users
      }
    }

    XMLExternalEntity {
      VulnerableScenarios {
        DirectXMLInput:
        - SOAP APIs
        - XML-RPC
        - XML file uploads
        - Configuration file parsing
        - RSS/Atom feed processing

        IndirectXML:
        - JSON/other format converted to XML server-side
        - Office documents (DOCX, XLSX, PPTX are ZIP with XML)
        - SVG files (XML-based)
        - SAML assertions
        - PDF with XFA forms
      }

      PreventionByLanguage {
        Java {
          ```java
          DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
          dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
          dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
          dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
          dbf.setExpandEntityReferences(false);
          ```
        }

        Python {
          ```python
          from lxml import etree
          parser = etree.XMLParser(resolve_entities=False, no_network=True)
          # Or use defusedxml library
          ```
        }

        PHP {
          ```php
          libxml_disable_entity_loader(true);
          // Or use XMLReader with proper settings
          ```
        }

        NodeJS {
          ```javascript
          // Use libraries that disable DTD processing by default
          // If using libxmljs, set { noent: false, dtdload: false }
          ```
        }

        DotNet {
          ```csharp
          XmlReaderSettings settings = new XmlReaderSettings();
          settings.DtdProcessing = DtdProcessing.Prohibit;
          settings.XmlResolver = null;
          ```
        }
      }

      XXEPreventionChecklist {
        - [ ] Disable DTD processing entirely if possible
        - [ ] Disable external entity resolution
        - [ ] Disable external DTD loading
        - [ ] Disable XInclude processing
        - [ ] Use latest patched XML parser versions
        - [ ] Validate/sanitize XML before parsing if DTD needed
        - [ ] Consider using JSON instead of XML where possible
      }
    }

    PathTraversal {
      VulnerablePatterns {
        ```python
        # VULNERABLE
        file_path = "/uploads/" + user_input
        file_path = base_dir + request.params['file']
        template = "templates/" + user_provided_template
        ```
      }

      PreventionStrategies {
        AvoidUserInputInPaths {
          ```python
          # Instead of using user input directly
          # Use indirect references
          files = {'report': '/reports/q1.pdf', 'invoice': '/invoices/2024.pdf'}
          file_path = files.get(user_input)  # Returns None if invalid
          ```
        }

        CanonicalizationAndValidation {
          ```python
          import os

          def safe_join(base_directory, user_path):
              # Ensure base is absolute and normalized
              base = os.path.abspath(os.path.realpath(base_directory))

              # Join and then resolve the result
              target = os.path.abspath(os.path.realpath(os.path.join(base, user_path)))

              # Ensure the commonpath is the base directory
              if os.path.commonpath([base, target]) != base:
                  raise ValueError("Error!")

              return target
          ```
        }

        InputSanitization {
          - Remove or reject `..` sequences
          - Remove or reject absolute path indicators (`/`, `C:`)
          - Whitelist allowed characters (alphanumeric, dash, underscore)
          - Validate file extension if applicable
        }
      }

      PathTraversalChecklist {
        - [ ] Never use user input directly in file paths
        - [ ] Canonicalize paths and validate against base directory
        - [ ] Restrict file extensions if applicable
        - [ ] Test with various encoding and bypass techniques
      }
    }
  }

  SecurityHeadersChecklist {
    Include these headers in all responses:

    ```
    Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
    Content-Security-Policy: [see XSS section]
    X-Content-Type-Options: nosniff
    X-Frame-Options: DENY
    Referrer-Policy: strict-origin-when-cross-origin
    Cache-Control: no-store (for sensitive pages)
    ```
  }

  GeneralSecurityPrinciples {
    When generating code, always:
    1. Validate all input server-side -- Never trust client-side validation alone
    2. Use parameterized queries -- Never concatenate user input into queries
    3. Encode output contextually -- HTML, JS, URL, CSS contexts need different encoding
    4. Apply authentication checks -- On every endpoint, not just at routing
    5. Apply authorization checks -- Verify the user can access the specific resource
    6. Use secure defaults
    7. Handle errors securely -- Don't leak stack traces or internal details to users
    8. Keep dependencies updated -- Use tools to track vulnerable dependencies

    When unsure, choose the more restrictive/secure option and document the security consideration in comments.
  }
}
