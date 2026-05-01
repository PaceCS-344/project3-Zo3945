import { useState, useEffect } from 'react';

const USERNAME = 'Zo3945';

// Hook to fetch GitHub repos
export function useGitHubRepos() {
  const [repos, setRepos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(`https://api.github.com/users/${USERNAME}/repos?sort=updated&per_page=20`)
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setRepos(data);
        } else {
          setError('Could not load repos');
        }
        setLoading(false);
      })
      .catch(() => {
        setError('Failed to fetch repos');
        setLoading(false);
      });
  }, []);

  return { repos, loading, error };
}

// Hook to fetch GitHub profile
export function useGitHubProfile() {
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(`https://api.github.com/users/${USERNAME}`)
      .then(res => res.json())
      .then(data => {
        setProfile(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  return { profile, loading };
}
